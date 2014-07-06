# Server Configuration
# =================================================
# To configure the system add some `config.yml` file in the `local` folder like
# done in the `src` folder.

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
