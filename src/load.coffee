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
    console.log util.inspect config.origin, {depth: null}
    console.log "STOPPED"

    # combine all
    # validate
    # set

    cb()


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
    async.map list, (file, cb) ->
      fs.readFile file,
        encoding: 'UTF-8'
      , (err, text) ->
        return cb err if err
        # parse
        uri = "file://#{file}"
        parse text, uri, origin.parser, false, (err, obj) ->
          return cb err if err
          # make meta data
          meta = setMeta obj, uri, origin
          debug "loaded #{uri}"
          cb null, [obj, meta]
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
setOrigin = (origin, obj, meta, date, cb) ->
  # set filter
  if origin.filter and not object.isEmpty obj
    debug "set filter to #{origin.filter} in #{origin.uri}"
    # step into data
    res = object.path obj, origin.filter
    if res?
      obj = res
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
  # store in origin
  origin.value = obj
  origin.meta = meta
  origin.lastload = date
  cb()

# ### Parse text into object
parse = (text, uri, parser, quiet=false, cb) ->
  unless parser in ['yaml', 'js', 'json', 'xml', 'ini']
    # autodetect parser on content
    parse text, uri, 'xml', true, (err, obj) ->
      return cb null, obj if obj
      parse text, uri, 'ini', true, (err, obj) ->
        return cb null, obj if obj
        parse text, uri, 'yaml', true, (err, obj) ->
          return cb null, obj if obj
          parse text, uri, 'json', true, (err, obj) ->
            return cb null, obj if obj
            parse text, uri, 'js', true, (err, obj) ->
              return cb null, obj if obj
              debug chalk.red "#{uri} failed in all parsers"
              cb()
    return
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
        cb null, vm.runInNewContext "x=#{text}"
      catch err
        debug chalk[color] "#{uri} failed in #{parser} parser: #{err.message}"
        return cb()
    when 'json'
      try
        result = JSON.parse stripComments text
      catch err
        debug chalk[color] "#{uri} failed in #{parser} parser: #{err.message}"
        return cb()
      cb null, result
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
        cb null, result
    else
      cb new Error "Parser for #{parser} not found"

# ### Remove comments
# This is used within the JSON importer because JSON originally won't allow
# comments. But comments are a good as help and for uncommenting something
# temporarily.
stripComments = (code) ->
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
