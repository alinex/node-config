# Configuration
# =================================================
# This package will give you an easy way to load and use configuration settings in 
# your application or module.



# Node Modules
# -------------------------------------------------

# include base modules
path = require 'path'
async = require 'async'
yaml = require 'js-yaml'
debug = require('debug')('server:startup')
errorHandler = require 'alinex-error'
util = require 'alinex-util'
util.object.addToPrototype()


class Config
  @_data: {}
  @_load: (name) ->
    @_data[name] = {}
        
  @_has: (name, key) ->
    @_load name unless @_data[name]?
    @_data[name]?[key]?
  @_get: (name, key) ->
    @_load name unless @_data[name]?
    @_data[name]?[key]
    
  constructor: (@name) ->
  has: (key) -> @constructor._has @name, key
  get: (key) -> @constructor._get @name, key

module.exports = Config

#Config = require 'alinex-config'
#config = new Config 'test'
#config.get 'db'



# Load configuration files
# -------------------------------------------------
# Merge the configuration from `src` and `locale` (priority on locale).
module.exports.load = (name, cb = ->) ->
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
