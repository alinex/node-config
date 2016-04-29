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
yaml = null # loaded on demand
vm = null # loaded on demand
coffee = null # loaded on demand
properties = null # loaded on demand
ini = null # loaded on demand
xml2js = null # loaded on demand
# include more alinex modules
fs = require 'alinex-fs'
util = require 'alinex-util'
validator = require 'alinex-validator'


# Initialize origins
# -------------------------------------------------

exports.init = (config, cb) ->
  debug "load all unloaded configurations"
  # step through origins
  origins = listOrigins config.origin
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
    parse text, uri, origin.parser, false, (err, obj) ->
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
    parse body, uri, origin.parser, false, (err, obj) ->
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

ext2parser =
  yml: 'yaml'
  yaml: 'yaml'
  js: 'js'
  javascript: 'javascript'
  json: 'json'
  cson: 'coffee'
  coffee: 'coffee'
  xml: 'xml'
  ini: 'ini'
  properties: 'properties'

# ### Parse text into object
parse = (text, uri, parser, quiet=false, cb) ->
  # auto detection
  list = ['xml', 'ini', 'properties', 'coffee', 'yaml', 'json', 'js']
  unless parser in list
    detect = list[0..]
    ext = fspath.extname(uri).substring 1
    if type = ext2parser[ext]
      i = detect.indexOf type
      detect.splice i, 1 if i > -1
      detect.unshift type
    result = null
    errors = []
    async.detectSeries detect, (type, cb) ->
      parseFormat text, uri, type, true, (err, obj) ->
        if err
          errors.push err.message
          debug chalk.grey "#{uri} failed in #{err.message}"
        result = obj
        cb null, not err? and obj?
    , (err, ok) ->
      unless ok
        return cb new Error "Could not find any valid format for #{uri}:\n#{errors.join '\n'}"
      cb null, result
    return
  # parse direct given format only
  parseFormat text, uri, parser, quiet, (err, result) ->
    err = new Error "#{uri} failed in #{err.message}" if err
    cb err, result

# ### Parse given Format
parseFormat =  (text, uri, parser, quiet=false, cb) ->
  # parse specified format
  color = if quiet then 'grey' else 'red'
  debug chalk.grey "try loading #{uri} as #{parser}"
  # parser given
  switch parser
    when 'yaml'
      yaml ?= require 'js-yaml'
      try
        result = yaml.safeLoad text
      catch error
        error.message = error.message.replace 'JS-YAML: ', ''
        return cb new Error chalk[color] "#{parser} parser: #{error.message.replace /[\s^]+/g, ' '}"
      cb null, result
    when 'js'
      vm ?= require 'vm'
      try
        result = vm.runInNewContext "x=#{text}"
      catch error
        return cb new Error chalk[color] "#{parser} parser: #{error.message}"
      cb null, result
    when 'json'
      try
        result = JSON.parse text
      catch error
        return cb new Error chalk[color] "#{parser} parser: #{error.message}"
      cb null, result
    when 'coffee'
      coffee ?= require 'coffee-script'
      try
        text = "module.exports =\n  " + text.replace /\n/g, '\n  '
        m = new module.constructor()
        m._compile coffee.compile(text), uri
      catch error
        return cb new Error chalk[color] "#{parser} parser: #{error.message}"
      cb null, m.exports
    when 'properties'
      properties ?= require 'properties'
      properties.parse text,
        sections: true
        namespaces: true
      , (err, result) ->
        if err
          return cb new Error chalk[color] "#{parser} parser: #{err.message}"
        unless propertiesCheck result
          return cb new Error chalk[color] "#{parser} parser: Unexpected characters []{}/
          in key name found"
        cb null, result
    when 'ini'
      ini ?= require 'ini'
      try
        result = ini.decode text
      catch error
        return cb new Error chalk[color] "#{parser} parser: #{error.message}"
      # detect failed parsing
      if not result?
        return cb new Error chalk[color] "#{parser} parser: could not parse any result"
      if result['{']
        return cb new Error chalk[color] "#{parser} parser: Unexpected token { at start"
      for k, v of result
        if v is true and k.match /:/
          return cb new Error chalk[color] "#{parser} parser: Unexpected key name containing
          ':' with value true"
      cb null, result
    when 'xml'
      xml2js ?= require 'xml2js'
      xml2js.parseString text, {explicitArray: false}, (err, result) ->
        if err
          return cb new Error chalk[color] "#{parser} parser: #{err.message.replace /\n/g, ' '}"
        # optimize result of attributes
        cb null, xmlOptimize result
    else
      cb new Error chalk[color] "Parser for #{parser} not found"

# ### Optimize parsed cml
xmlOptimize = (data) ->
  return data unless typeof data is 'object'
  if Array.isArray data
    # seep analyze array
    result = []
    for v in data
      result.push xmlOptimize v
    return result
  result = {}
  for k, v of data
    # set value
    if k is '_'
      result.value = v
    # set attributes
    else if k is '$'
      for s, w of xmlOptimize v
        result[s] = w
    # keep other but check contents
    else
      result[k] = xmlOptimize v
  return result

# ### Check that the properties parser for correct result
propertiesCheck = (data) ->
  return true unless typeof data is 'object'
  for k, v of data
    if v is null or ~'[]{}/'.indexOf k.charAt 0
      return false
    return false unless propertiesCheck v
  return true

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
