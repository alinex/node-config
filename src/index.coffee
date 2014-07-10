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
                cb null
              when '.js'
                cb null
              when '.coffee'
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

  # ### Create instance for access
  constructor: (@name, cb = ->) ->
    unless name
      throw new Error "Could not initialize Config class without configuration name."
    Config._load name, (err) ->
      throw err if err
      cb()

  # ### Check if key exist
  has: (key) ->
    throw new Error "Configuration for #{name} is not loaded." unless Config._data[@name]?
    Config._data[@name]?[key]?
  # ### Get the value of a key
  get: (key) ->
    throw new Error "Configuration for #{name} is not loaded." unless Config._data[@name]?
    Config._data[@name]?[key]
    
module.exports = Config
