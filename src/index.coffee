###
API Usage
=================================================
This package will give you an easy way to load and use configuration settings
into your application or module.
###


# Node Modules
# -------------------------------------------------
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
# Definition of the registry as container for the configuration values.

# Stores the list of origins (search list for configuration). Each element has the
# following Structure:
#
# `Array<Object>` with
# - uri - `String` path to search with possible placeholders
# - parser - `String` type to use for parsing the data (optional)
# - filter - `Object` which part to use (optional)
# - path - `String` where to put it in the data structure (optional)
# - type - `String` content type (optional, default is 'config')
module.exports.origin = []

# Store the validation schema used after loading new values or on setting an element.
#
# `Object<Object>` structure for {@link alinex-validator}
module.exports.schema =
  type: 'object'

# Complete registry content after the object has been vaildated.
#
# `Object`
module.exports.value = {}

# Meta data for each data element which helps in detecting problems by specifying
# there each element comes from.
#
# `Object`
module.exports.meta = {}

# Event listener for `onChange` event.
#
# `Object`
module.exports.listener = {}


###
Setup Origin
-------------------------------------------------
The origin is the place the configuration data comes from. For alinex-config you
have the possibility to specify multiple search paths, you can also overload
configurations with another file in higher priority and combine values from
different files together.
So the specification of the origin is the main part and is the base to build
the registry data.

#3 Origin Structure

To setup the origin for the configuration module you have to extend the origin
list by adding a new origin object.

The single origin object describes where to find the configuration, what to use
and where to put them in the final data structure. It contains the following
possible elements:

- uri - `String` path to search with possible placeholders
- parser - `String` type to use for parsing the data (optional)
- filter - `Object` which part to use (optional)
- path - `String` where to put it in the data structure (optional)

__URI Type__

The following URI types are possible here:

- No Protocol => using the file protocol
- `file://` => load from local file
- `http://` or `https://` => load from web service

__File search__

You may access files absolute from root or relative from current directory:

    file:///etc/myapp.yml   # absolute path
    /etc/myapp.yml          # shortcut

    file://config/myapp.yml # relative path
    config/myapp.yaml       # shortcut

You can search by using asterisk as placeholder or a double asterisk to
go multiple level depth:

    /etc/myapp.*            # search for any extension
    /etc/myapp/*.yml        # find all files with this extension
    /etc/myapp/*            # find all files in the directory
    /etc/myapp/* /*.yml     # find one level depth
    /etc/myapp/**           # find all files in directory or subdirectories
    /etc/myapp/** /*.yml    # find files in the directory or subdirectories

See more about the possible matchings at
{@link alinex-fs/README.md.html#file%2Fpath%20matching alinex-fs}.

__Parsing data__

The data loaded from the given URI will be parsed if it is a string. You may
set one of the following parsers in `parser` to use:

- yaml
- json
- xml
- ini
- properties
- coffee
- javascript

But if you don't specify it, it will be auto detected based on the file extension
or the contents itself. See more info about each type at {@link alinex-format}.

__Combine contents__

Use the `filter` path to only use a subset of the loaded structure and the
`path` to specify where it belongs to.

    filter: 'test'
    path: 'database/test'

This will only use the `test` settings from the loaded data and put them into
`data.database.test`.

If multiple files are found (maybe through multiple origins) their contents
will be merged together in the order they are specified in the origin tree list.
This means that the later one will overwrite the earlier one if they have values
for the same element.

__Order__

The origin structure is a tree list which will be processed top down. This means
that you can add new origin objects at the top to use them as defaults or at
the end of the list to make this the highest priority.

::: detail
In case of registering applications using `register()` they will add a sublist
with their search paths instead of an single entry. See more about this in the description below.
:::
###

###
#3 Extend Origin List
To maintain the order you can add at the front using `unshiftOrigin()` or at the
end using `pushOrigin()`.
###

###
#4 pushOrigin(conf)
Add a new element to the origin list.

@param {Object} conf origin specification (see above)
###
module.exports.pushOrigin = (conf) ->
  conf.type ?= 'config'
  @origin.push conf

###
#4 unshiftOrigin(conf)
Add a new element at the start of the origin list.

@param {Object} conf origin specification (see above)
###
module.exports.unshiftOrigin = (conf) ->
  conf.type ?= 'config'
  @origin.unshift conf


###
#3 Registering Applications

An application have the possibility to search for their file based configuration
on multiple locations out of the box:

- var/src/config - defaults in the source code
- var/local/config - local within the installed program
- /etc/<app> - global for the application
- ~/.app/config - user specific settings

As described above the last has the highest priority.

To support this in an easy way you may use the `register` method which if given
an application name and the app directory will do everything for you.

``` coffee
config.register myapp, __dirname,
  uri: '*.yml'
```

Like you see, you may also add the  attributes from the normal configuration
like `uri`, `filter` and `path`.

You may also register a module. Therefore give `null` as application name and
it will only add the first two paths based on the given directory.

If you won't have your settings in the 'config' folder you may specify another
one using `folder: "..."` as additional parameter.
###

###
#4 register(app, basedir, setup)

@param {String} [app] name of the application (in the filesystem)
@param {String} [basedir] folder in which the application is installed
@param {Object} setup origin specification (see above)
###
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


###
Setup Schema
---------------------------------------------------
The schema defines some validation and optimization rules which has to be
processed before using the values. If the validation fails it will return a
descriptive Error and don't use the values.
###

###
``` coffee
config.setSchema '/',
  type: 'object'
  allowedKeys: true
  keys:
    name:
      type: 'string'
    job:
      type: 'string'
, (err) ->
  # go on and load the data
```

To set a schema, give the root path for the schema and it's values which describe
the concrete data format. The real validation is done using the
[Validator](http://alinex.github.io/node-validator). Therefore look at the
description there for all the possibilities you have.

@param {String} path the configuration path to which the schema belongs to
@param {Object} schema the schema definition for {@link alinex-validator}
@param {Function(Error)} [cb] callback to be called after set and loaded objects validated
with `Error` if validation failed
@see {@link setSchemaSync}
###
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

###
``` coffee
config.setSchemaSync '/',
  type: 'object'
  allowedKeys: true
  keys:
    name:
      type: 'string'
    job:
      type: 'string'
```

To set a schema, give the root path for the schema and it's values which describe
the concrete data format. The real validation is done using the
[Validator](http://alinex.github.io/node-validator). Therefore look at the
description there for all the possibilities you have.

@param {String} path the configuration path to which the schema belongs to
@param {Object} schema the schema definition for {@link alinex-validator}
@throws {Error} if it could not be validated
@see {@link setSchema}
###
module.exports.setSchemaSync = deasync module.exports.setSchema


###
Initialize
-------------------------------------------------
After everything is setup you have to call the `init()` method to initialize
it. This will:

- search for the configurations
- load them
- parse them
- combine all together
- check using schema

After everything is done the given callback is called.

You may also call this method if you didn't know if everything is initialized.
It will check and return immediately if nothing to do.
###

###
@param {Function(Error)} cb callback with `Error` on any problems
@see {@link initSync}
###
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

###
@throw {Error} on any problems
@see {@link init}
###
module.exports.initSync = deasync module.exports.init


###
Reload
----------------------------------------------------------
###


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

###
Access
----------------------------------------------------------
###

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

###
Other Types
----------------------------------------------------------
###

# search only for other types like templates
module.exports.typeSearch = (type, cb) -> load.typeSearch this, type, cb




# Setup the general search path
module.exports.register 'alinex'
module.exports.register 'alinex', null,
  folder: 'template'
  type: 'template'
