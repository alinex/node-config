# Load files
# =================================================
# This will load and validate the configuration.
#
# Each origin will get the additional values:
# - `value` - `Object` structure read from source
# - `meta` - `Object` meta information of each element as map with the elements
# path as key (separated by dots)
#   - `uri` - `String` location of source object
#   - `origin` - `Object` reference to origin object
#   - `value` - the elements original value
# - `loaded` - `Boolean` set to true if successfully loaded
# - `lastload` - `Date` of the time the data is read from source


# Node Modules
# -------------------------------------------------
debug = require('debug')('config:load')
chalk = require 'chalk'
async = require 'async'
fspath = require 'path'
request = null # loaded on demand
# include more alinex modules
fs = require 'alinex-fs'
util = require 'alinex-util'
validator = require 'alinex-validator'
format = require 'alinex-format'


# Initialize origins
# -------------------------------------------------

# @param {Object} config reference to the config module
# @param {Function(Error)} cb callback with `Error` on any problems
exports.init = (config, cb) ->
  debug "load all unloaded configurations"
  # step through origins
  origins = listOrigins config.origin
  .filter (e) -> e.type is 'config'
  async.each origins, loadOrigin, (err) ->
    return cb err if err
    # combine all
    value = {}
    meta = {}
    # put together
    for origin in origins
      util.extend 'MODE OVERWRITE', value, origin.value
      util.extend meta, origin.meta
    # validate
    validate config, value, (err, value) ->
      return cb err if err
      # collect events to send
      listeners = Object.keys config._events
      if listeners.length
        events = diff '', config.value, value
        .concat diff '', value, config.value
        .filter (e) -> e in listeners
        events = util.array.unique events
        events.sort()
      else
        events = []
      # set
      config.value = value
      config.meta = meta
      # send events
      if events.length
        config.emit e for e in events
      cb()

# Get a list of changes in path (with parents).
#
# @param {String} path to the element under inspection
# @param old value from current config
# @param new value, just read
diff = (path, old, value) ->
  changes = []
  switch typeof value
    when 'undefined'
      changes = []
    when 'object'
      if Array.isArray value
        for e, i in value
          changes = changes.concat diff "#{path}/#{i}", old?[i], e
      else
        for k, e of value
          changes = changes.concat diff "#{path}/#{k}", old?[k], e
    else
      # add value as changed
      if old isnt value
        parent = path ? '/'
        changes.push parent
        loop
          parent = fspath.dirname parent
          changes.push parent
          break if parent.length is 1
  changes


# Loading
# -------------------------------------------------

# Get the flat list of origins.
#
# @param {Array<Object>} obj origin list as defined
# @return {Array<Object>} flat list of origins
listOrigins = exports.listOrigins = (obj) ->
  list = []
  for el in obj
    if Array.isArray el
      list = list.concat listOrigins el
    else
      list.push el
  list

# Load origin if necessary. This fills up the `origin.value`, `origin.meta` and
# sets `origin.loaded` on success.
#
# @param {Object} origin to load
# @param {Function(Error)} cb callback with `Error` on any problems
loadOrigin = (origin, cb) ->
  return cb() if origin.loaded
  uri = if ~origin.uri.indexOf '://' then origin.uri else 'file://' + origin.uri
  [proto, path] = uri.split '://'
  switch proto
    when 'file'
      return loadFiles origin, path, cb
    when 'http', 'https'
      return loadRequest origin, uri, cb
    else
      return cb new Error "Unknown protocol #{proto}"
  cb()

# Load origin from files. This fills up the `origin.value`, `origin.meta` and
# sets `origin.loaded` on success.
#
# @param {Object} origin to store results
# @param {String} path extracted from the `origin.uri`
# @param {Function(Error)} cb callback with `Error` on any problems
loadFiles = (origin, path, cb) ->
  # find files
  parts = path.match ///
    ^
    (
      [^?*[{@]*$    # everything till end without pattern
    |
      [^?*[{@]*\/   # everything without pattern (dirs)
    )?
    (.*)            # part containing pattern to end
    $
  ///
  [path, pattern] = parts[1..] if parts.length > 1
  path ?= process.cwd() # make relative links absolute
  path = "#{process.cwd()}/#{path}" unless path[0] is '/'
  path = fspath.resolve path
  unless pattern
    file = path
    path = fspath.dirname path if path?
    date = new Date()
    return loadFile origin, "file://#{path}", file, (err, result) ->
      if err
        return cb err unless err.code is 'ENOENT'
        debug chalk.magenta "Failure #{err.message}!" if debug.enabled
        origin.loaded = true
        origin.lastload = date
        return cb()
      [value, meta] = result
      setOrigin origin, value, meta, date, cb
  fs.find path,
    filter:
      type: 'f'
      include: pattern
      dereference: true
      mindepth: path.split(/\//).length - 1 unless pattern
      maxdepth: path.split(/\//).length - 1 unless pattern
  , (err, list) ->
    date = new Date()
    if err
      return cb err unless err.code is 'ENOENT'
      # not existing file is no problem and will be ignored
      debug chalk.magenta "Failure #{err.message}!" if debug.enabled
      origin.loaded = true
      origin.lastload = date
      return cb()
    # load them
    path = "file:///#{util.string.trim path, '/'}"
    async.map list, (file, cb) ->
      loadFile origin, path, file, cb
    , (err, objects) ->
      return cb err if err
      # combine
      obj = []
      meta = []
      for [o, m] in objects
        obj.push o
        meta.push m
      obj = util.extend.apply {}, obj
      meta = util.extend.apply {}, meta
      setOrigin origin, obj, meta, date, cb

# Load origin from file. This fills up the `origin.value`, `origin.meta` and
# sets `origin.loaded` on success.
#
# @param {Object} origin to store results
# @param {String} path extracted from the `origin.uri` but made absolute
# @param {String} file absolute path of file to load
# @param {Function(Error, Array)} cb callback with `Error` on any problems or
# - `value` - `Object` complete value structure
# - `meta` - `Object` meta information
loadFile = (origin, path, file, cb) ->
  fs.readFile file,
    encoding: 'UTF-8'
  , (err, text) ->
    return cb err if err
    # parse
    uri = "file:///#{util.string.trim file, '/'}"
    format.parse text, (origin.parser ? uri), (err, obj) ->
      return cb err if err
      # get additional path
      add = uri.substring path.length+1
      add = add[0..-fspath.extname(add).length-1]
      add = add[0..-7] if util.string.ends add, '/index'
      list = []
      if add
        list = list.concat add.split('/')[0..-2] if ~add.indexOf '/'
        list.push fspath.basename add
      add = '/' + list.join '/' if list.length
      # put object deeper
      value = ref = {}
      for k in list
        ref[k] = {}
        ref = ref[k]
      ref[k] = v for k, v of obj
      # make meta data
      meta = setMeta value, uri, origin
      debug "loaded #{uri}" if debug.enabled
      cb null, [value, meta]

# Load origin from web resource. This fills up the `origin.value`, `origin.meta` and
# sets `origin.loaded` on success.
#
# @param {Object} origin to store results
# @param {String} uri to retrieve
# @param {Function(Error)} cb callback with `Error` on any problems
loadRequest = (origin, uri, cb) ->
  debug "load   #{uri}" if debug.enabled
  date = new Date()
  # make request
  request ?= require 'request'
  request uri, (err, response, body) ->
    # error checking
    return cb err if err
    if response.statusCode isnt 200
      return cb new Error "Server send wrong return code: #{response.statusCode}"
    return cb() unless body?
    # parse content
    format.parse body, (origin.parser ? uri), (err, obj) ->
      return cb err if err
      meta = setMeta obj, uri, origin
      debug "loaded #{uri}" if debug.enabled
      setOrigin origin, obj, meta, date, cb

# Create the meta data structure.
#
# @param {Object} obj parsed data structure
# @param {String} uri location of source object
# @param {Object} origin to store results
# @param {String} [prefix] path within structure on recursive calls
# @return {Object} meta data Object with information of each element and the
# path separated by '.' as key
# - `uri` - `String` location of source object
# - `origin` - `Object` reference to origin object
# - `value` - the elements original value
setMeta = (obj, uri, origin, prefix='') ->
  meta = {}
  for k, v of obj
    path = "#{prefix}/#{k}"
    if typeof v is 'object'
      for key, val of setMeta v, uri, origin, path
        meta[key] = val
    else
      meta[path] = [
        uri: uri
        origin: origin
        value: v
      ]
  return meta

# Set the extracted information in the origin element.
#
# @param {Object} origin to store results
# @param {Object} value complete parsed value structure
# @return {Object} meta data object with information of each element from {@link setMeta}
# @param {Date} date from when the source was read
# @param {Function(Error)} cb callback with `Error` on any problems
setOrigin = (origin, value, meta, date, cb) ->
  # set filter
  if origin.filter and not util.object.isEmpty value
    debug "set filter to #{origin.filter} in #{origin.uri}" if debug.enabled
    # step into data
    res = util.object.path value, origin.filter
    if res?
      value = res
      # optimize the meta list
      filter = "#{origin.filter}/"
      filter = "/#{filter}" unless filter[0] is '/'
      res = {}
      for k, v of meta
        # remove entries not starting with /filter/
        continue unless util.string.starts k, filter
        # replace /filter/ with / in all meta paths
        res[k.substring filter.length-1] = v
      meta = res
    else
      if debug.enabled
        debug chalk.red "Could not set filter #{origin.filter} in #{origin.uri}"
  # set specific path
  if origin.path
    debug "set under path #{origin.path} for #{origin.uri}" if debug.enabled
    # add path to value
    path = util.string.trim origin.path, '/'
    obj = ref = {}
    for k in path.split '/'
      ref[k] = {}
      ref = ref[k]
    ref[k] = v for k, v of value
    value = obj
    # add path to meta
    ref = {}
    ref["/#{path}/#{k}"] = v for k, v of meta
    meta = ref
  # store in origin
  origin.value = value
  origin.meta = meta
  origin.loaded = true
  origin.lastload = date
  if debug.enabled
    debug "loaded origin #{origin.uri} with #{origin.path ? 'ROOT'}: \n
    #{ chalk.grey util.inspect origin.value, {depth: null}}"
  cb()


# Validation
# ---------------------------------------------
# Run the validation before setting the values into the internal registry.

# @param {Object} config reference to the config module
# @param {Object} value the value structure to check
# @param {Function(Error)} cb callback with `Error` on any problems
validate = exports.validate = (config, value, cb) ->
  debug "validate results"
  validator.check
    name: 'config'
    title: 'Configuration'
    value: value
    schema: config.schema
  , cb


# Type Search
# --------------------------------------------

# @param {Object} config reference to the config module
# @param {String} type the name of this files
# @param {Function(Error, Object)} cb callback with the results map or an `Error` on any problems
exports.typeSearch = (config, type, cb) ->
  origins = listOrigins config.origin
  .filter (e) -> e.type is type
  async.map origins, (origin, cb) ->
    # find files
    parts = origin.uri.match ///
      ^
      (
        [^?*[{@]*$    # everything till end without pattern
      |
        [^?*[{@]*\/   # everything without pattern (dirs)
      )?
      (.*)            # part containing pattern to end
      $
    ///
    [path, pattern] = parts[1..] if parts.length > 1
    path ?= process.cwd() # make relative links absolute
    path = "#{process.cwd()}/#{path}" unless path[0] is '/'
    path = fspath.resolve path
    unless pattern
      return fs.exists path, (exists) ->
        return cb() unless exists
        map = {}
        name = fspath.basename path
        name = "#{origin.path.trim '/'}/name" if origin.path
        map[name] = path
        cb null, map
    # search with pattern
    fs.find path,
      filter:
        type: 'f'
        include: pattern
        dereference: true
        mindepth: path.split(/\//).length - 1 unless pattern
        maxdepth: path.split(/\//).length - 1 unless pattern
    , (err, list) ->
      return cb() if err
      map = {}
      for f in list
        name = f[path.length+1..]
        name = "#{origin.path.trim '/'}/name" if origin.path
        map[name] = f
      cb null, map
  , (err, results) ->
    return cb err if err
    map = {}
    util.extend map, res for res in results
    cb null, map
