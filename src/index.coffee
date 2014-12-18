# Configuration
# =================================================
# This package will give you an easy way to load and use configuration settings
# into your application or module.

# Architecture
# -------------------------------------------------
# The configuration handling consists of the class as central information
# storage like a registry and instances which reflect individual configurations.
# All values will be loaded and stored in the class  and the instances will
# get a reference to their data.
#
# A special behavior is the reloading of the configuration after the files
# changed. This is done using a watcher on the file search path which will
# automatically load all configurations which are changed into the class cache.
# Through class events the instances will get informed if anything changed, so
# they can reload their data and emit events for their application listeners
# to update this data, too.


# Node Modules
# -------------------------------------------------

# include base modules
debug = require('debug')('config')
debugValue = require('debug')('config:value')
chalk = require 'chalk'
util = require 'util'
path = require 'path'
async = require 'async'
chokidar = require 'chokidar'
EventEmitter = require('events').EventEmitter
# include more alinex modules
fs = require 'alinex-fs'
object = require('alinex-util').object
validator = require 'alinex-validator'


# Configuration class
# -------------------------------------------------
class Config extends EventEmitter

  # ### Setup
  # Set the default search paths for configuration file search. It may be
  # overridden from the outside.
  base = ROOT_DIR ? '.'
  @search: [
    path.join base, 'var', 'src', 'config'
    path.join base, 'var', 'local', 'config'
  ]
  # Switch to enable watching for configuration changes globally.
  @watch: false

  # ### Find configuration files
  # This may be used to search for specific configuration files.
  @find: (name, cb) ->
    debug "Search for config files '#{name}'"
    name = if name then "/#{name}" else ''
    pattern = new RegExp "#{name}(/[^/]+)*?(-[^/]+)?\.(ya?ml|json|xml|js|coffee)$"
    async.map @search, (dir, cb) ->
      fs.find dir,
        include: pattern
        type: 'file'
      , cb
    , (err, results) ->
      names = {}
      for list in results
        for entry in list
          names[path.basename entry, path.extname entry] = true
      cb null, Object.keys names

  # ### Factory
  # Get an instance for the name. This enables the system to use the same
  # Config instance anywhere.
  @_instances: {}
  @instance: (name) ->
    unless @_instances[name]?
      @_instances[name] = new Config name
    @_instances[name]

  # ### Remove comments
  # This is used within the JSON importer because JSON originally won't allow
  # comments. But comments are a good as help and for uncommenting something
  # temporarily.
  @_stripComments = (code) ->
    uid = "_" + +new Date()
    primitives = []
    primIndex = 0
    # remove the strings
    code.replace(/(['"])(\\\1|.)+?\1/g, (match) ->
      primitives[primIndex] = match
      (uid + "") + primIndex++
    )
    # remove regular expressions
    .replace(/([^\/])(\/(?!\*|\/)(\\\/|.)+?\/[gim]{0,3})/g, (match, $1, $2) ->
      primitives[primIndex] = $2
      $1 + (uid + "") + primIndex++
    )
    # Remove multi-line comments that contain would be single-line delimiters
    # E.g. /* // <--
    .replace(/\/\/.*?\/?\*.+?(?=\n|\r|$)|\/\*[\s\S]*?\/\/[\s\S]*?\*\//g, "")
    # Remove single and multi-line comments, no consideration of inner-contents
    .replace(/\/\/.+?(?=\n|\r|$)|\/\*[\s\S]+?\*\//g, "")
    # Remove multi-line comments that have a replaced ending (string/regex)
    # Greedy, so no inner strings/regexes will stop it.
    .replace(RegExp("\\/\\*[\\s\\S]+" + uid + "\\d+", "g"), "")
    # Bring back strings & regexes
    .replace RegExp(uid + "(\\d+)", "g"), (match, n) -> primitives[n]

  # ### Create instance
  # This will also load the data if not already done. Don't call this directly
  # better use the `instance()` method which implements the factory pattern.
  constructor: (@name) ->
    unless name
      throw new Error "Could not initialize Config class without configuration name."
    # Set high value of listeners because multiple functions may wait but if it
    # is to less it should be checked before running as much functions against the
    # configuration.
    @setMaxListeners 100
    # Instance specific search path set to class
    @search = Config.search

    # ### Default values
    # Storage for default values, which have to be set with config name.
    # The first level is the configuration name and it have to be set directly
    # from the outside.
    @default = {}

    # ### Configuration structure
    # This will hold all the configuration data. You may also reference this from
    # your code because it is neither removed but truncated and refilled on reload.
    @data = {}

  # ### Start loading
  # This will call load the configuration and start watching for reloads (if
  # enabled).
  loaded: false
  loading: false
  load: (cb = ->) ->
    return cb null, @data if @loaded
    # Event listener methods which will be set and only one will be called. The
    # other one will be removed.
    sendError = (err) ->
      @removeListener 'change', sendChange
      cb err, @data
    sendChange = ->
      @removeListener 'error', sendError
      cb null, @data
    @once 'error', sendError
    @once 'change', sendChange
    # start loading if not already done
    @_load() unless @loading

  # ### Reloading
  # This will be called from the file change watcher.
  reload: (cb = ->) ->
    if @loading
      # event listener to wait for reloading
      sendError: (err) ->
        @removeListener 'change', sendReload
      sendReload: ->
        @removeListener 'error', sendError
        @reload cb
      @once 'change', sendReload
      @once 'error', sendError
      return
    @loaded = false
    @_load()

  _load: =>
    @loading = true
    debug "Start loading config for '#{@name}'", @search
    for dir in  @search
      debug chalk.grey "search in #{path.resolve dir}"
    @_watch()
    async.map @search, (dir, cb) =>
      fs.find dir,
        dereference: true
        type: 'file'
        include: @name + '?(-?*).{yml,yaml,json,xml,js,coffee}'
      , (err, list) =>
        if err
          debug "Skipped search in '#{dir}' because of access problems."
          return cb null, {}
        # skip also if no files found
        return cb null, {} unless list
        list.sort (a,b) ->
          x = path.basename a, path.extname(a)
          y = path.basename b, path.extname(b)
          +(x > y) || +(x is y) - 1
        async.map list, (file, cb) ->
          debug "Reading #{file}..."
          fs.readFile file, 'utf8', (err, data) ->
            return cb err if err
            # convert data to object
            switch path.extname file
              when '.yml', '.yaml'
                yaml = require 'js-yaml'
                cb null, yaml.safeLoad data
              when '.json'
                cb null, JSON.parse Config._stripComments data
              when '.xml'
                xml2js = require 'xml2js'
                xml2js.parseString data, cb
              when '.js'
                m = new module.constructor
                m._compile data, file
                cb null, m.exports
              when '.coffee'
                coffee = require 'coffee-script'
                m = new module.constructor
                m._compile coffee.compile(data), file
                cb null, m.exports
              else
                cb new Error "Config type not supported: #{file}"
        , (err, results) =>
          # combine if multiple files found
          values = object.extend.apply @data, results
          cb null, values
    , (err, results) =>
      return @emit 'error', err if err
      # check if at least one file loaded
      loaded = 0
      for obj in results
        loaded++ if obj?
      unless loaded
        return @emit 'error', new Error "No configuration found for #{@name}!"
      # add default values
      if @default?
        results.unshift @default
      # combine everything together clean the object and refill to be updated
      # without resetting thee references
      delete @data[key] for key in Object.keys @data
      results.unshift @data
      object.extend.apply null, results
      debugValue "#{@name} => #{util.inspect @data}"
      unless @check?
        # done
        @loaded = true
        @loading = false
        @emit 'change'
        debug "Loaded #{@name} configuration successfully"
        return
      # run checks
      @check @name, @data, (err) =>
        @loaded = true
        @loading = false
        return @emit 'error', err if err
        debug "Loaded #{@name} configuration successfully"
        @emit 'change'

  # ### Set check routine
  check: null
  setCheck: (check, cb = ->) ->
    if typeof check is 'object'
      @check = (name, values, cb) ->
        validator.check name, check, values, cb
    else
      @check = check
    return cb() unless @loaded
    # run the check on the already loaded data
    debug "Running check on already loaded data."
    @check @name, @data, cb

  # ### Watching for file changes
  _watcher: null
  _watchdir: null
  _watch: ->
    return unless @constructor.watch
    jsondirs = JSON.stringify Config._search
    if @_watcher?
      # only skip if watcher initialized and dirs haven't changed
      return if jsondirs is @_watchdir
      # close old watcher
      @_watcher.close()
    return if @watch is false
    # start watching config dirs
    debug "Start watching for file changes...", @search
    @_watcher = null
    for dir in @search
      unless @_watcher?
        @_watcher = chokidar.watch dir,
          ignoreInitial: not @_watchdir?
      else
        @_watcher.add dir,
          ignoreInitial: not @_watchdir?
    @_watchdir = jsondirs
    # action for changes
    setTimeout =>
      @_watcher.on 'all', (event, file) =>
        debug chalk.grey "watcher: #{event} #{file}"
        return unless event in ['add', 'change', 'unlink']
        debug "Reloading config for #{@name}"
        @reload()
    , 1000
  watch: null
  watching: (enabled) ->
    @watch = Boolean enabled
    _watch()

# Exports
# -------------------------------------------------
# The configuration class is exported directly.
module.exports = Config


#watcher = chokidar.watch '/home/alex/a3/dvb-media/var/src/config',
#  ignoreInitial: true
#watcher.on 'all', (event, file) =>
#  console.log chalk.grey "wwwwwww: #{event} #{file}"
