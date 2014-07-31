# Configuration
# =================================================
# This package will give you an easy way to load and use configuration settings
# into your application or module.


# Node Modules
# -------------------------------------------------

# include base modules
debug = require('debug')('config')
path = require 'path'
async = require 'async'
EventEmitter = require('events').EventEmitter
# include more alinex modules
fs = require 'alinex-fs'
object = require('alinex-util').object

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
  @events.setMaxListeners 100

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
    Config._check[name].push check
    return cb() unless Config._data?[name]?
    # run the check on the already loaded data
    debug "Running check on already loaded data."
    check name, Config._data[name], cb

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
      check name, values, cb
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
        cb()
    # only initialize instance if data already loaded
    if Config._data[_name]?
      @_init()
      return @emit 'ready'
    Config._load _name, (err) =>
      @emit 'error', err if err
      @_init()
      @emit 'ready'

  # ### Initialize or reinitialize the instance data
  _init: =>
    delete @key for key of @
    @[key] = value for key, value of Config._data[@_name]
    Config.events.on 'change', (name) ->
      if name is @_name
        @_init()
        @emit 'change'

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
