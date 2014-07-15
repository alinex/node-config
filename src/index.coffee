# Configuration
# =================================================
# This package will give you an easy way to load and use configuration settings in
# your application or module.



# Node Modules
# -------------------------------------------------

# include base modules
debug = require('debug')('config')
path = require 'path'
fs = require 'alinex-fs'
async = require 'async'
object = require('alinex-util').object

require('alinex-error').install()

# Configuration class
# -------------------------------------------------
class Config
  # ### Setup of the configuration loader
  # set the search path for configs
  base = ROOT_DIR ? '.'
  @search = [
    path.join base, 'var', 'src', 'config'
    path.join base, 'var', 'local', 'config'
  ]
  # central storage for all configuration data
  @_data: {}
  # storage for default values, which have to be set with config name
  @default: {}

  # ### Add function for checks
  @_check: {}
  @addCheck = (name, check) ->
    Config._check[name] = [] unless Config._check[name]?
    Config._check[name].push check
    # run the check on the already loaded data
    if Config._data?[name]?
      debug "Running check on already loaded data."
      check name, Config._data[name], (err) ->
        throw new Error "The configuration for #{name} was checked: #{err}" if err

  # ### Load values
  # This may be the initial loading or a reload after the files have changed.
  @_load: (name, cb = ->) ->
    debug "Start loading config for '#{name}'", Config.search
    async.map Config.search, (dir, cb) ->
      fs.find dir,
        include: name + '?(-?*).{yml,yaml,json,js,coffee}'
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
        results.unshift {}, Config.default[name]
      # combine everything together
      values = object.extend.apply @, results
      # use values if no checks defined
      unless Config._check?[name]?
        Config._data[name] = values
        return cb()
      # run given checks for validation and optimization of values
      debug "Run the checks for #{name} config."
      async.each Config._check[name], (check, cb) ->
        check name, values, cb
      , (err) ->
        # store resulting object
        Config._data[name] = values
        return cb new Error "Config #{name} was checked: #{err}" if err
        cb()

  # ### Remove comments helper
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
    # Remove single-line comments that contain would-be multi-line delimiters
    # E.g. // Comment /* <--
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

  # ### Create instance for access
  # This will also load the data if not already done.
  constructor: (name, cb = ->) ->
    unless name
      throw new Error "Could not initialize Config class without configuration name."
#    @_name = name
    # only initialize instance if data already loaded
    if Config._data[name]?
      @_init name
      return cb()
    Config._load name, (err) =>
      return cb err if err
      @_init name
      cb()

  # ### Initialize or reinitialize the instance data
  _init: (name) ->
    delete @key for key of @
    @[key] = value for key, value of Config._data[name]
    
module.exports = Config
