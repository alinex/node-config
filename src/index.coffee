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
  @search = [
    path.join base, 'var', 'src', 'config'
    path.join base, 'var', 'local', 'config'
  ]
  # Central storage for all configuration data. Each instance will reference the
  # values there. The first level is the configuration name.
  @_data: {}

  # Class based events
  @events: new EventEmitter

  # ### Default values
  # Storage for default values, which have to be set with config name.
  # The first level is the configuration name and it have to be set directly
  # from the outside.
  @default: {}

  # ### Add check function
  # The first level is again the configuration name. Each check function have
  # to be asynchronous and have to call the given callback after done.
  @_check: {}
  @addCheck = (name, check, cb = ->) ->
    Config._check[name] = [] unless Config._check[name]?
    if typeof check is 'object'
      Config._check[name].push (name, values, cb) ->
        validator.check name, values, check, cb
    else
      Config._check[name].push check
    return cb() unless Config._data?[name]?
    # run the check on the already loaded data
    debug "Running check on already loaded data."
    check name, Config._data[name], cb

  # ### Find configuration files
  # This may be used to search for specific configuration files.
  @find: (name, cb) ->
    debug "Search for config files '#{name}'"
    name = if name then "/#{name}" else ''
    pattern = new RegExp "#{name}(/[^/]+)*?(-[^/]+)?\.(ya?ml|json|xml|js|coffee)$"
    async.map Config.search, (dir, cb) ->
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

  # ### Load values
  # This may be the initial loading or a reload after the files have changed.
  @_load: (name, cb = ->) ->
    debug "Start loading config for '#{name}'", Config.search
    async.map Config.search, (dir, cb) ->
      fs.find dir,
        type: 'file'
        include: name + '?(-?*).{yml,yaml,json,xml,js,coffee}'
      , (err, list) ->
        if err
          debug "Skipped search in '#{dir}' because of access problems."
          return cb null, {}
        # skip also if no files found
        return cb null, {} unless list
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
                cb "Config type not supported: #{file}"
        , (err, results) ->
          # combine if multiple files found
          values = object.extend.apply @, results
          cb null, values
    , (err, results) ->
      # add default values
      if Config.default?[name]?
        results.unshift Config.default[name]
      # combine everything together
      Config._set name, {}, object.extend.apply(@, results), cb

  @_watch = =>
    jsondir = JSON.stringify Config.search
    if @_watcher?
      # only skip if watcher initialized and dirs haven't changed
      return if jsondir is @_watchdir
      # close old watcher
      @_watcher.close()
    # start watching config dirs
    debug "Start watching for file changes...", Config.search
    for dir in Config.search
      unless @_watcher?
        @_watcher = chokidar.watch dir,
          ignoreInitial: not @_watchdir?
      else
        @_watcher.add dir
    @_watchdir = jsondir
    # action for changes
    @_watcher.on 'all', (event, file) =>
      return unless event in ['add', 'change', 'unlink']
      # find config name
      name = path.basename file, path.extname file
      name = name.replace /-.*$/, ''
      # start loading
      @_load name, (err) =>
        if err
          console.log "Failed to reload #{name} configuration because of: #{err}".red
          return
        # emit events
        @events.emit 'change', name

  # ### Set config for name
  # internal method to set given config to object and trigger events
  @_set = (name, base, values, cb = ->) ->
    # extend given values with new ones
    values = object.extend base, values
    # use values if no checks defined
    unless Config._check?[name]?
      Config._data[name] = values
      return cb()
    # run given checks for validation and optimization of values
    debug "Run the checks for #{name} config."
    async.each Config._check[name], (check, cb) ->
      check "config.#{name}", values, cb
    , (err) =>
      # store resulting object
      Config._data[name] = values
      @events.emit 'change', name
      return cb err if err
      cb()

  # ### Remove comments
  # This is used within th JSON importer because JSON won't allow comments.
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

  # instance based events
  events: new EventEmitter

  # ### Create instance
  # This will also load the data if not already done.
  constructor: (@_name, cb) ->
    unless _name
      throw new Error "Could not initialize Config class without configuration name."
    # support callback through event wrapper
    if cb?
      @on 'error', (err) ->
        cb err
        cb = ->
      @on 'ready', ->
        cb null, @
    # only initialize instance if data already loaded
    if Config._data[_name]?
      @_init()
      return @emit 'ready'
    Config._load _name, (err) =>
      # initialize instance if everything went ok
      @emit 'error', err if err
      @_init()
      @emit 'ready'
    # start watching files if not already done
    Config._watch()
    Config.events.on 'change', (name) =>
      return unless name is @_name
      @_init()
      @emit 'change'

  # ### Initialize or reinitialize the instance data
  _init: =>
    delete @key for key of @
    @[key] = value for key, value of Config._data[@_name]

  # ### Set config
  # Set the given configuration values.
  set: (values, cb = ->) ->
    Config._set _name, Config._data[_name], values, (err) ->
      @emit 'change'
      cb err


# Exports
# -------------------------------------------------
# The configuration class is exported directly.
module.exports = Config
