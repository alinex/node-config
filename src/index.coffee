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
debug = require('debug')('config')
debugValue = require('debug')('config:value')
chalk = require 'chalk'
util = require 'util'
fspath = require 'path'
# load other alinex modules
{string, object} = require 'alinex-util'
# load helper modules
load = require './load'

# Define singleton instance
# -------------------------------------------------
module.exports =

  # Data container
  # -------------------------------------------------

  # configuration for loading
  origin: []
  # validation schema
  schema:
    type: 'object'
  # contents
  value: {}
  # meta data for each data element
  meta: {}
  # event listener for onChange event
  listener: {}

  # Setup methods
  # -------------------------------------------------

  pushOrigin: (conf) -> @origin.push conf
  unshiftOrigin: (conf) -> @origin.unshift conf

  # name - application name
  # basedir - path
  register: (app, basedir, setup = {} ) ->
    uri = string.trim(setup.uri, '/') ? '*'
    if basedir
      list = []
      dir = fspath.resolve basedir
      # add src
      list.push
        uri: "#{dir}/var/src/config/#{uri}"
        parser: setup.parser
        path: setup.path
        filter: setup.filter
      # add local
      list.push
        uri: "#{dir}/var/local/config/#{uri}"
        parser: setup.parser
        path: setup.path
        filter: setup.filter
    # add global
    list.push
      uri: "/etc/#{app}/#{uri}"
      parser: setup.parser
      path: setup.path
      filter: setup.filter
    # add user
    dir = process.env.HOME ? process.env.USERPROFILE
    list.push
      uri: "#{dir}/.#{app}/config/#{uri}"
      parser: setup.parser
      path: setup.path
      filter: setup.filter
    @origin.push list

  setSchema: (path, schema, cb = -> ) ->
    path = string.trim(path, '/').split '/'
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
    object.extend ref, schema
    # revalidate if already loaded
    return cb() if object.isEmpty @value
    debug "revalidate against schema because #{path ? '/'} changed"
    load.validate this, @value, (err, value) ->
      return cb err if err
      @value = value

  # ### Initialize
  init: (cb) ->
    debug "initialize configuration system"
    load.init this, (err) =>
      return cb err if err
      debugValue "new configuration \n#{chalk.grey util.inspect @value, {depth: null}}"
      cb()

  # ### Reload
  # This will re-import everything from scratch and if successful overwrite the
  # previous values.
  reload: (cb) ->
    debug "reload configuration system"
    # step through origins and set as unloaded
    origin.loaded = false for origin in load.listOrigins @origin
    # run init again
    load.init this, (err) =>
      return cb err if err
      debugValue "new configuration \n#{chalk.grey util.inspect @value, {depth: null}}"
      cb()


  # Access methods
  # -------------------------------------------------

  get: (path) ->
    if typeof path is 'string'
      path = string.trim(path, '/').split '/'
    return @value unless path.length and path[0]
    # get sub path
    ref = @value
    return null unless ref[p]?
    ref = ref[p] for p in path
    return ref

