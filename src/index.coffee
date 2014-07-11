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

# Configuration class
# -------------------------------------------------
class Config
  # ### Setup of the configuration loading
  # set the search path for configs
  base = ROOT_DIR ? '.'
  @search = [
    path.join base, 'var', 'src', 'config'
    path.join base, 'var', 'local', 'config'
  ]
  # central storage for all configuration data
  @_data: {}

  # ### Load values
  # This may be the initial loading or a reload after the files have changed.
  @_load: (name, cb = ->) ->
    debug "start loading config for '#{name}'"
    async.map Config.search, (dir, cb) ->
      fs.find dir,
        include: name + '?(-?*).{yml,yaml,json,js,coffee}'
      , (err, list) ->
        if err
          debug "skipped search in '#{dir}' because of access problems"
          return cb null, {}
        # skip also if no files found
        return cb null, {} unless list
        async.map list, (file, cb) ->
          debug "reading #{file}..."
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
#                cb null, require './'+file
                cb null
              when '.coffee'
#                coffee = require 'coffee-script'
#                cb null, require './'+file
                cb null
              else
                cb "config type not supported: #{file}"
        , (err, results) ->

          # combine if multiple files found
          values = object.extend.apply @, results
          cb null, values
    , (err, results) ->
      values = object.extend.apply @, results
      # validate and optimize values
      Config._data[name] = values
      cb()

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
  constructor: (name, cb = ->) ->
    unless name
      throw new Error "Could not initialize Config class without configuration name."
#    @_name = name
    Config._load name, (err) =>
      throw err if err
      @_init name
      cb()

  _init: (name) ->
    delete @key for key of @
    @[key] = value for key, value of Config._data[name]
    
module.exports = Config
