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

  register: (app, conf) ->
    console.log 'TO BE DONE'

  setSchema: (path, schema) ->
    console.log 'TO BE DONE'

  # ### Initialize
  init: (cb) ->
    debug "initialize configuration system"
    load.init this, cb

  # Access methods
  # -------------------------------------------------
