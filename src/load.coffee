# Load files
# =================================================
# This will load and validate the configuration.

# Node Modules
# -------------------------------------------------

# include base modules
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
    for origin in origins
      # put together
      util.extend value, origin.value
      util.extend meta, origin.meta
    # validate
    validate config, value, (err, value) ->
      return cb err if err
      # set
      config.value = value
      config.meta = meta
      cb()

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


# ### Validate new value before store
validate = exports.validate = (config, value, cb) ->
  debug "validate results"
  validator.check
    name: 'config'
    value: value
    schema: config.schema
  , cb

# Loading
# -------------------------------------------------

# ### Get a flat list of origins
listOrigins = exports.listOrigins = (obj) ->
  list = []
  for el in obj
    if Array.isArray el
      list = list.concat listOrigins el
    else
      list.push el
  list

# ### Load origin if necessary
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

# ### Load file origin
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
        debug chalk.magenta "Failure #{err.message}!"
        origin.loaded = true
        origin.lastload = date
        return cb()
      [value, meta] = result
      setOrigin origin, value, meta, date, cb
  fs.find path,
    type: 'f'
    include: pattern
    dereference: true
    mindepth: path.split(/\//).length - 1 unless pattern
    maxdepth: path.split(/\//).length - 1 unless pattern
  , (err, list) ->
    date = new Date()
    if err
      return cb err unless err.code is 'ENOENT'
      debug chalk.magenta "Failure #{err.message}!"
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
      debug "loaded #{uri}"
      cb null, [value, meta]

# ### Load file origin
loadRequest = (origin, uri, cb) ->
  debug "load   #{uri}"
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
      debug "loaded #{uri}"
      setOrigin origin, obj, meta, date, cb

# ### Set the extracted information to the origin element
setOrigin = (origin, value, meta, date, cb) ->
  # set filter
  if origin.filter and not util.object.isEmpty value
    debug "set filter to #{origin.filter} in #{origin.uri}"
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
      debug chalk.red "Could not set filter #{origin.filter} in #{origin.uri}"
  # set specific path
  if origin.path
    debug "set under path #{origin.path} for #{origin.uri}"
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
  origin.lastload = date
  debug "loaded #{origin.path ? 'ROOT'} with: \n
  #{ chalk.grey util.inspect origin.value, {depth: null}}"
  cb()

# ### Set Meta Data to all elements
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
