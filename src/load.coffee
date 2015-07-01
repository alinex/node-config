# Configuration
# =================================================
# This package will give you an easy way to load and use configuration settings
# into your application or module.

# Architecture
# -------------------------------------------------
# The configuration handling consists of a singleton class as central information
# storage like a registry. On access you will get references to the data.
#
# A special behavior is the reloading of the configuration after the files
# changed. This is done using a watcher on the file search path which will
# automatically load all configurations which are changed into the class cache.
# Through class events the instances will get informed if anything changed, so
# they can reload their data and emit events for their application listeners
# to update this data, too.


# Node Modules
# -------------------------------------------------

# include base modules
debug = require('debug')('config:load')
chalk = require 'chalk'
util = require 'util'
fspath = require 'path'
chokidar = require 'chokidar'
EventEmitter = require('events').EventEmitter
# include more alinex modules
fs = require 'alinex-fs'
async = require 'alinex-async'
{string, object} = require 'alinex-util'
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
      object.extend value, origin.value
      object.extendArrayConcat meta, origin.meta
    # validate
    debug "validate results"
    validator.check
      name: 'config'
      value: value
      schema: config.schema
    , (err, value) ->
      return cb err if err
      # set
      config.value = value
      config.meta = meta
      cb()

validate = (origin, cb) ->
  return unless origin.schema
  validator

# Loading
# -------------------------------------------------

# ### Get a flat list of origins
listOrigins = (obj) ->
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
  debug "check #{uri}"
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
  [all, path, pattern] = path.match /^([^?*[{@]*\/)?(.*)$/
  path ?= process.cwd() # make relative links absolute
  fs.find path,
    type: 'f'
    include: pattern
    dereference: true
    mindepth: path.split(/\//).length - 1 unless pattern
    maxdepth: path.split(/\//).length - 1 unless pattern
  , (err, list) ->
    return cb err if err
    # load them
    date = new Date()
    path = "file:///#{string.trim (fspath.resolve path), '/'}"
    async.map list, (file, cb) ->
      fs.readFile file,
        encoding: 'UTF-8'
      , (err, text) ->
        return cb err if err
        # parse
        uri = "file:///#{string.trim (fspath.resolve file), '/'}"
        parse text, uri, origin.parser, false, (err, obj) ->
          return cb err if err
          # get additional path
          add = uri.substring path.length+1
          list = []
          list = string.trim(origin.path, '/').split '/' if origin.path
          if add
            list = list.concat add.split '/' if ~add.indexOf '/'
            list.push fspath.basename(add).replace /\..*/, ''
          add = '/' + list.join '/' if list.length
          # put object deeper
          value = ref = {}
          for k in list
            ref[k] = {}
            ref = ref[k]
          ref[k] = v for k, v of obj
          # make meta data
          meta = setMeta value, uri, origin, add
          debug "loaded #{uri}"
          cb null, [value, meta]
    , (err, objects) ->
      return cb err if err
      # combine
      obj = []
      meta = []
      for [o, m] in objects
        obj.push o
        meta.push m
      obj = object.extend.apply {}, obj
      meta = object.extendArrayConcat.apply {}, meta
      setOrigin origin, obj, meta, date, cb

# ### Load file origin
loadRequest = (origin, uri, cb) ->
  debug "load   #{uri}"
  date = new Date()
  # make request
  request = require 'request'
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
  if origin.filter and not object.isEmpty value
    debug "set filter to #{origin.filter} in #{origin.uri}"
    # step into data
    res = object.path value, origin.filter
    if res?
      value = res
      # optimize the meta list
      filter = "#{origin.filter}/"
      filter = "/#{filter}" unless filter[0] is '/'
      res = {}
      for k, v of meta
        # remove entries not starting with /filter/
        continue unless string.starts k, filter
        # replace /filter/ with / in all meta paths
        res[k.substring filter.length-1] = v
      meta = res
    else
      debug chalk.red "Could not set filter #{origin.filter} in #{origin.uri}"
  # set specific path
  if origin.path
    debug "set under path #{path} for #{origin.uri}"
    # remove starting / if present
    path = if origin.path[0] is '/' then origin.path[1..] else origin.path
    # add path to value
    ref = res = {}
    lastkey = null
    for p in origin.path.split '/'
      ref = ref[lastkey] if lastkey
      ref[p] = {}
      lastkey = p
    ref[lastkey] = value
    value = res
    # add path to meta
    ref = {}
    ref["/#{path}#{k}"] = v for k, v of meta
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

# ### Parse text into object
parse = (text, uri, parser, quiet=false, cb) ->
  # auto detection
  unless parser in ['yaml', 'js', 'json', 'coffee', 'xml', 'ini']
    detect = ['xml', 'ini', 'coffee', 'yaml', 'json', 'js']
    ext = fspath.extname(uri).substring 1
    if type = ext2parser[ext]
      i = detect.indexOf type
      detect.splice i, 1 if i > -1
      detect.unshift type
    debug "autodetect format as: #{detect}"
    result = null
    async.detectSeries detect, (type, cb) ->
      parse text, uri, type, true, (err, obj) ->
        result = obj
        cb not err? and obj?
    , -> cb null, result
    return
  # parse specified format
  color = if quiet then 'grey' else 'red'
  debug chalk.grey "try loading #{uri} as #{parser}"
  # parser given
  switch parser
    when 'yaml'
      yaml = require 'js-yaml'
      try
        result = yaml.safeLoad text
      catch err
        debug chalk[color] "#{uri} failed in #{parser} parser: #{err.message}"
        return cb()
      cb null, result
    when 'js'
      vm = require 'vm'
      try
        result = vm.runInNewContext "x=#{text}"
      catch err
        debug chalk[color] "#{uri} failed in #{parser} parser: #{err.message}"
        return cb()
      cb null, result
    when 'json'
      try
        result = JSON.parse text
      catch err
        debug chalk[color] "#{uri} failed in #{parser} parser: #{err.message}"
        return cb()
      cb null, result
    when 'coffee'
      coffee = require 'coffee-script'
      try
        text = "module.exports =\n  " + text.replace /\n/g, '\n  '
        m = new module.constructor()
        m._compile coffee.compile(text), uri
      catch err
        debug chalk[color] "#{uri} failed in #{parser} parser: #{err.message}"
        return cb()
      cb null, m.exports
    when 'ini'
      ini = require 'ini'
      try
        result = ini.decode text
      catch err
        debug chalk[color] "#{uri} failed in #{parser} parser: #{err.message}"
        return cb()
      # detect failed parsing
      return cb() if not result? or result['{']
      for k, v of result
        return cb() if v is true and k.match /:/
      cb null, result
    when 'xml'
      xml2js = require 'xml2js'
      xml2js.parseString text, {explicitArray: false}, (err, result) ->
        if err
          debug chalk[color] "#{uri} failed in #{parser} parser: #{err.message}"
          return cb()
        # optimize result of attributes
        cb null, xmlOptimize result
    else
      cb new Error "Parser for #{parser} not found"

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
