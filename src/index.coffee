# Configuration
# =================================================
# This package will give you an easy way to load and use configuration settings in
# your application or module.



# Node Modules
# -------------------------------------------------

# include base modules
debug = require('debug')('server:startup')
path = require 'path'
fs = require 'alinex-fs'
async = require 'async'
object = require('alinex-util').object

#yaml = require 'js-yaml'

# Configuration class
# -------------------------------------------------
class Config
  # set the search path for configs
  base = ROOT_DIR ? '.'
  search = [
    path.join base, 'var', 'local', 'config'
    path.join base, 'var', 'src', 'config'
  ]
  # central storage for all configuration data
  @_data: {}
  # load or reload the configuration
  @_load: (name) ->
    debug "loading config for '#{name}'"
    @_data[name] = {}
    async.map search, (dir, cb) ->
      fs.find dir,
        include: name + '?(-?*).{yml,yaml,json,js,coffee}'
      , (err, list) ->
        return cb err if err
        async.map list, (file, cb) ->
          debug "reading #{file}..."
          fs.readfile file, 'utf8', (err, data) ->
            return cb err if err
            # convert data to object
            switch path.extname file
              when '.yml', '.yaml'
                cb null, yaml.safeLoad data
              when '.jason'
              when '.js'
              when '.coffee'
              else
                cb "config type not supported: #{file}"
        , (err, results) ->          
          # combine if multiple files found
          values = object.extend.apply @, results
          # cb
    , (err, results) ->
      values = object.extend.apply @, results
      # validate and optimize values
      @-data[name] = values
      cb()
        
  @_has: (name, key) ->
    @_load name unless @_data[name]?
    @_data[name]?[key]?
  @_get: (name, key) ->
    @_load name unless @_data[name]?
    @_data[name]?[key]
    
  constructor: (@name) ->
  has: (key) -> @constructor._has @name, key
  get: (key) => @constructor._get @name, key    

module.exports = Config

#Config = require 'alinex-config'
#config = new Config 'test'
#config.get 'db'



# Load configuration files
# -------------------------------------------------
# Merge the configuration from `src` and `locale` (priority on locale).
load = (name, cb = ->) ->
  file = name + '.yml'
  async.map [
    path ROOT_DIR, 'var', 'local', 'config', file
    path ROOT_DIR, 'var', 'src', 'config', file
  ], (file, cb) ->
    fs.exists file, (exists) ->
      return cb null, {} unless exists
    fs.readfile file, 'utf8', (err, data) ->
      return cb err if err
      cb yaml.safeLoad data
  , (err, results) ->
    return cb err if err
    # merge results
    return cb null, results[0] unless results[1]
    cb null, results[0].extend results[1]
