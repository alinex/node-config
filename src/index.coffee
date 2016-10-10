###
API Usage
=================================================
This package will give you an easy way to load and use configuration settings
into your application or module.
###



# Node Modules
# -------------------------------------------------

# include base modules
debug = require('debug')('config')
debugValue = require('debug')('config:value')
debugAccess = require('debug')('config:access')
chalk = require 'chalk'
fspath = require 'path'
deasync = require 'deasync'
# load other alinex modules
util = require 'alinex-util'
# load helper modules
load = require './load'


# Data container
# -------------------------------------------------
# configuration for loading
#  uri: '/home/alex/github/node-config/test/data/app/var/local/config/*',
#  parser: undefined,
#  path: undefined,
#  filter: undefined
#  type: # content type, defaults to config
module.exports.origin = []
# validation schema

module.exports.schema =
  type: 'object'
# contents
module.exports.value = {}
# meta data for each data element
module.exports.meta = {}
# event listener for onChange event
module.exports.listener = {}

  # Setup methods
  # -------------------------------------------------

module.exports.pushOrigin = (conf) ->
  conf.type ?= 'config'
  @origin.push conf
module.exports.unshiftOrigin = (conf) ->
  conf.type ?= 'config'
  @origin.unshift conf

  # name - application name
  # basedir - path
module.exports.register = (app, basedir, setup = {} ) ->
  uri = util.string.trim(setup.uri, '/') ? '**'
  setup.folder ?= 'config'
  setup.type ?= 'config'
  list = []
  if basedir
    dir = fspath.resolve basedir
    # add src
    list.push
      uri: "#{dir}/var/src/#{setup.folder}/#{uri}"
      type: setup.type
      parser: setup.parser
      path: setup.path
      filter: setup.filter
    # add local
    list.push
      uri: "#{dir}/var/local/#{setup.folder}/#{uri}"
      type: setup.type
      parser: setup.parser
      path: setup.path
      filter: setup.filter
  if app
    # add global
    list.push
      uri: "/etc/#{app}/#{setup.folder}/#{uri}"
      type: setup.type
      parser: setup.parser
      path: setup.path
      filter: setup.filter
    # add user
    dir = process.env.HOME ? process.env.USERPROFILE
    list.push
      uri: "#{dir}/.#{app}/#{setup.folder}/#{uri}"
      type: setup.type
      parser: setup.parser
      path: setup.path
      filter: setup.filter
  debug chalk.grey "register urls: #{list.map (e) -> e.uri}"
  @origin.push list

module.exports.setSchema = (path, schema, cb = -> ) ->
  path = util.string.trim(path, '/').split '/'
  ref = @schema
  # go into path
  if path.length and path[0]
    for p in path
      # create structure if missing
      ref.type ?= 'object'
      ref.keys ?= {}
      ref.keys[p] ?= {}
      ref = ref.keys[p]
  # remove previous settings
  delete ref[k] for k of ref
  # set new schema
  util.extend ref, util.clone schema
  # revalidate if already loaded
  return cb() if util.object.isEmpty @value
  debug "revalidate against schema because #{path ? '/'} changed"
  load.validate this, @value, (err, value) ->
    return cb err if err
    @value = value

module.exports.setSchemaSync = deasync module.exports.setSchema

module.exports.typeSearch = (type, cb) -> load.typeSearch this, type, cb

  # ### Reload
  # This will re-import everything from scratch and if successful overwrite the
  # previous values.
module.exports.reload = (cb) ->
  debug "reload configuration system"
  # step through origins and set as unloaded
  origin.loaded = false for origin in load.listOrigins @origin
  # run init again
  load.init this, (err) =>
    return cb err if err
    debugValue "new configuration \n#{chalk.grey util.inspect @value, {depth: null}}"
    cb()

module.exports.reloadSync = deasync module.exports.reload

  # Access methods
  # -------------------------------------------------

module.exports.get = (path) ->
  if typeof path is 'string'
    path = util.string.trim(path, '/').split '/'
    debugAccess "returning #{path.join '/'}"
  return @value unless path.length and path[0]
  # get sub path
  ref = @value
  for p in path
    return null unless ref[p]?
    ref = ref[p]
  debugAccess "not found #{path.join '/'}" unless ref?
  return ref

# ### Initialize
module.exports.init = util.function.onceTime module.exports, (cb) ->
  debug "initialize configuration system"
  needLoad = false
  for origin in load.listOrigins @origin
    if origin.loaded
      debug chalk.grey "origin url: #{origin.uri} (already loaded)"
      continue
    debug chalk.grey "origin url: #{origin.uri}"
    needLoad = true
  return cb() unless needLoad
  load.init this, (err) =>
    return cb err if err
    debugValue "new configuration \n#{chalk.grey util.inspect @value, {depth: null}}"
    cb()

module.exports.initSync = deasync module.exports.init

# Setup the general search path
module.exports.register 'alinex'
module.exports.register 'alinex', null,
  folder: 'template'
  type: 'template'
