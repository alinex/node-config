Package: alinex-config
=================================================

[![Build Status](https://travis-ci.org/alinex/node-config.svg?branch=master)](https://travis-ci.org/alinex/node-config)
[![Dependency Status](https://gemnasium.com/alinex/node-config.png)](https://gemnasium.com/alinex/node-config)

This package will give you an easy way to load and use configuration settings in
your application or module.

It will read named files in different formats (YAML, JSON, XML, JavaScript,
CoffeeScript) and supports validation and optimization/completion. Also the
configuration will automatically be updated on changes in the file system
and may inform it's dependent objects.

The major features are:

- over writable configurations
- allows different file formats
- supports value validation
- supports value modification rules
- automatically reloads on file changes

It is one of the modules of the [Alinex Universe](http://alinex.github.io/node-alinex)
following the code standards defined there.


Install
-------------------------------------------------

The easiest way is to let npm add the module directly:

``` sh
npm install alinex-config --save
```

[![NPM](https://nodei.co/npm/alinex-config.png?downloads=true&stars=true)](https://nodei.co/npm/alinex-config/)


Usage
-------------------------------------------------

To easily make your module configurable you need to load the class first:

``` coffee
Config = require 'alinex-config'
```

To load a specific configuration you have to instantiate it with it's name. The
factory method will help to only have one instance per each configuration name.

``` coffee
config = Config.instance 'server'
```

Before using it you now have to load the configuration. That will be started
after calling `load`. After that you got the settings as properties for easy
access.

``` coffee
config.load (err, data) ->
  if err
    # report error and stop
  # work with configuration values
  if config.data.url
    console.log 'Started at '+config.data.url
```

To make accessing of the config values shorter you may also use:

``` coffee
Config.get 'server', search, check, (err, config) ->
  # now you may use the values
```

This allows you to optionally set search order and validation checks.


API
-------------------------------------------------

### Class configuration

- [Config.search](src/index.coffee#search) - to set the search path
- `Config.watch` - (boolean) set to true to enable reloading globally

### Static calls

- [Config.find()](src/index.coffee#find configuration files) - to search for
  existing configuration files
- [Config.instance()](src/index.coffee#factory) - to get a config instance
- Config.get() - as easy access method

### Instances

- [new Config()](src/index.coffee#create instance) - to create a new config
  instance
- config.search - to set the search path
- [config.default](src/index.coffee#default values) - to set the default values
  (this can also be done through the check)
- [config.setCheck()](src/index.coffee#set check) - to validate or
  optimize the values
- config.load() - loading the configuration
- config.reload() - loading the configuration
- config.watching(<bool>) - start or stop the watching of config changes
- config.data - values are directly accessible
- config.getData() - get data from config instance, name or config object

### Instance Events

The following events are supported:

- `error` - then something fails (with message as data)
- `change` - the instance data has changed after loading


Search and order
-------------------------------------------------

Configurations are searched in all supported file formats under the given
directories and below.

The files are searched in the following order of directories:

- `var/src/config`
- `var/local/config`
- `~/.<process>/config`
- `/etc/<process>/config`

And within these the files are searched with the given name in different formats
(maybe also with mixed formats):

- `<name>.yml`
- `<name>-part1.yml`
- `<name>-part2.yml`

The order is essential because the later file will overwrite the same keys of
the earlier ones. So the order looks like:

1. Use each directory in given search list order
2. Use files with only base names
3. Use the partial extensions in alphabetical order

To configure where to look for files you may give a list of directories:

``` coffee
Config.search = ['var/src/config', 'var/local/config']
```

This will set the search paths for all new instances but you may also define
the search paths on a single instance.


Overloading
-------------------------------------------------

If multiple directories given and/or multiple files (maybe in different formats)
were found they will overload each other.

This means if a value is set in two or more files the last will overwrite the
one before. But it will also combine the contents if different keys in an object
are used.

The files overload in the following order:

1. files alphabetically in directory
2. directories as specified in search path


File Formats
-------------------------------------------------

This configuration class allows multiple formats to be used alternatively or combined.
So you may use the format you know best. The following table will give a short
comparison.

|   Format    | YAML | JSON | XML |  JS | Coffee | INI | RDBMS | ObjDB |
|:------------|-----:|-----:|----:|----:|-------:|----:|------:|------:|
| Supported   |  yes |  yes | yes | yes |    yes |  no |    no |    no |
| Comments    |  yes | (yes)| yes | yes |    yes | yes |   yes | (yes) |
| Structure   |  yes |  yes | yes | yes |    yes |  no |   yes |   yes |
| Reloadable  |  yes |  yes | yes | yes |    yes | yes | (yes) | (yes) |
| Readiness   |  +++ |   ++ |   - |  ++ |    +++ |   + |     + |    ++ |
| Performance |   ++ |  +++ |   + | +++ |     ++ |  ++ |     - |     + |
| Common      |    + |   ++ | +++ |  -- |    --- |   + |     - |    -- |



### YAML

This is a simplified and best human readable language to write structured
information. See some examples at [Wikipedia](http://en.wikipedia.org/wiki/YAML).

Use the file extensions `yml` or `yaml`.

__Example__

title: YAML Test

``` yaml
# use an object
yaml:
  # include text elements
  name: test
  name2: 'commas has to be in quotes, too'
  description: >
    This may be a very long
    line in which newlines
    will be removed.
  # and some lists
  list: 1, 2, 3
  list2:
    - red
    - green
    - blue
```

### JSON

This format uses the javascript object notation a human readable structure. It
is widely used in different languages not only JavaScript. See description at
[Wikipedia](http://en.wikipedia.org/wiki/Json).

JSON won't allow comments but you may use JavaScript like comments using
`//` and `/*...*/` like known in javascript. They will be removed before
interpreting the file contents.

Use the file extension `json`.

``` json
{
  // use an object
  "json": {
    // include text elements
    "name": "test",
    // and a list of numbers
    "list": [1, 2, 3]
  }
}
```

### XML

The XML format should only use Tags and values, but no arguments.

Use the file extension `xml`.

``` xml
<?xml version="1.0" encoding="UTF-8" ?>
<!-- use an object -->
<xml>
  <!-- include a string -->
  <name>test</name>
  <!-- and a list of numbers -->
  <list>1</list>
  <list>2</list>
  <list>3</list>
</xml>
```

### JavaScript

Also allowed are normal JavaScript modules like done in node.js. The module must
export the configuration object.

Use the file extension `js`.

``` javascript
module.exports = {
  // use an object
  javascript: {
    // include a string
    name: "test",
    // and a list of numbers
    list: [1, 2, 3]
  }
}
```

### CoffeeScript

Like above you may write the modules in CoffeeScript.

Use the file extension `coffee`.

``` coffee
module.exports =
  # use an object
  coffee:
    # include a string
    name: "test"
    # and a list of numbers
    list: [1, 2, 3]
```

### Ini file

Not supported, yet.

``` ini
; use an object
; include a string
name = test
; and a list of numbers
list[] = 1
list[] = 2
list[] = 3
; and use groups
[group1]
name = group1
; and also subgroups
[group1.sub]
name = subgroup1
```

### RDBMS

Not supported, yet.

| lastchange       | group | key          |  value | comment |
|------------------|-------|:-------------|:-------|:--------|
| 2014-12-11 19:45 | test  | rdbms        | null   | use an object |
| 2014-12-11 19:45 | test  | rdbms.name   | "name" | include a string |
| 2014-12-11 19:45 | test  | rdbms.list   | null   | and a list of numbers |
| 2014-12-11 19:45 | test  | rdbms.list[] | 1      |  |
| 2014-12-11 19:45 | test  | rdbms.list[] | 2      |  |
| 2014-12-11 19:45 | test  | rdbms.list[] | 3      |  |

### Object DB

Not supported, yet.

Here, the JSON will be stored in the database like in the JSON file.


Default values
-------------------------------------------------

It is possible to set default values for each configuration on the class.

``` coffee
Config.default = { server: { url: 'http://localhost' } }
```

This will be set if not overwritten in any configuration file for the `server`
configuration.


Validation and Optimization
-------------------------------------------------

You may use synchronous functions, but asynchronous will be more widely
supported.
If asynchronous check-functions are given it is possible to validate and
manipulate the loaded configuration values, before they are used. You may also
add such check functions after you created the first instances. (But the newly
added toplevel config entries are not updated.)

You have two possibilities to declare checks. You may use an
[alinex-validator](http://alinex.github.io/node-validator) compatible structure
or use you own function.

### Validator structure

This is best used if now special methods like internal reference checks...
have to be done.

``` coffee
Config.addCheck 'server',
  title: "Testfile"
  description: 'the structure used to demonstrate here'
  check: 'type.string'
  maxLength: 25
, (err) ->
  # may get an error if values already loaded
```

### Check function

With the check function you may define what you want, but you also can combine
it with the validator.

``` coffee
myCheck = (name, values, cb) ->
  # change or check the values
  # ...
  # on error call cb('something is not ok');
  cb()

Config.addCheck 'server', myCheck, (err) ->
  # may get an error if values already loaded
```

The `name` here is the name of the configuration which may be used in reporting.
The `values` maybe changed.

If an error is returned it will also be returned while adding the check or within
the constructor. But it won't stop the processing. You may also throw an error
to really stop if a check failed.

This checks have to be added to the Config class using `Config.addCheck(name, check):`

### Predefined checks

Classes or functions which support this module often has predefined checks
to be used.

``` coffee
Config.addCheck 'server', AnyClass.check, (err) ->
  # may get an error if values already loaded
```

But if the configuration for AnyClass is only a subgroup of a bigger configuration
file you have to wrap the call in an additional function:

``` coffee
# the wrapper function
myCheck = (name, values, cb) ->
  # change the name to reflect change in reporting
  # call it with the subgroup
  AnyClass.check name+'.anygroup', values.anygroup, cb

Config.addCheck 'server', myCheck, (err) ->
  # may get an error if values already loaded
```

### Using alinex-validator

A very easy way to do validations is through the
[https://alinex.github.io/node-validator](alinex-validator) module. It let's
you define your validation rules as rule structure in an object.

``` coffee
Config.addCheck (name, values, cb) ->
  return validator.check(name, values, ->
    type: 'type.integer'
    options:
      min: 0,
      max: 100
  , cb
```

That's the way most alinex modules implement their own check methods.


Working with events
-------------------------------------------------
While the configuration may change you should listen to the `change` event which
will inform for any change in the current configuration. Now you have to reinit
everything which changed.

Keep in mind to alway unregister event listeners while no longer used to prevent
memory leaks.

An example might look like:

``` coffee
# create two listener methods
sendError = (err) ->
  config.removeListener 'change', sendChange
  # do something....
sendChange = ->
  config.removeListener 'error', sendError
  # do something....

# start listening
config.once 'error', sendError
config.once 'change', sendChange
```

Watching for changes
-------------------------------------------------
It is possible to watch for file changes and automatically reload the configuration
if something changes.

If any file in the configuration directory changes it will reload the data
and send an `change` event after validating.

This feature is disabled by default but may be enabled globally using

``` coffee
Config.watch = true
```

But do this before using the Config class!

You may also enable and disable this feature on each instance by calling

``` coffee
config.watching boolean
```


Examples
-------------------------------------------------

### Use in class for single init

``` coffee
Config = require 'alinex-config'
configcheck = require './configcheck'

class Spawn
  @init: (config = 'spawn', cb) ->
    return cb() if @config # already loaded
    @_configSource ?= config # store what to load
    # start resolving configuration
    Config.get @_configSource, [
      path.resolve path.dirname(__dirname), 'var/src/config'
      path.resolve path.dirname(__dirname), 'var/local/config'
    ], configcheck, (err, @config) ->
      # results stored, now check for errors
      console.error err if err
      cb err if cb?

  constructor: ->
    # do something

  run: (cb) ->
    @constructor.init null, (err) ->
```

Now you should use this class like:

``` coffee
Spawn.init 'spawn'
xxx = new Spawn()
xxx.run()
# or use the default config name
xxx = new Spawn()
xxx.run()
```


Submodule pattern
-------------------------------------------------

To make configuration work through a complex system of program, modules and
submodules the following pattern may help. (For better overview the example is
written in coffee script)

### Submodule

In the module you load the configuration class and make an init method which is used
to start loading the configuration.

``` coffee
Config = require 'alinex-config'

class Test

  @init: (@config = 'spawn', cb) ->
    debug "init or reinit spawn"
    # set config from different values
    if typeof @config is 'string'
      @config = Config.instance @config
      # add the module's directory the default
      @config.search.unshift path.resolve __dirname, 'var/src/config'
      # add the check methods
      @config.setCheck configcheck
    if @config instanceof Config
      @configClass = @config
      @config = @configClass.data
    @initDone = false # status set to true after initializing
    # set init status if configuration is loaded
    unless @configClass?
      cb() if cb?
      @initDone = true
    else
      # wait till configuration is loaded
      @configClass.load (err) =>
        console.error err if err
        cb err if cb?
        @initDone = true
```

This method can consume different informations:

- a string specifying the configuration file
- a already configured `Config` instance
- an object holding all the configuration values

And when the configuration is needed in example in an run method:

``` coffee
run: (cb) ->
  # start initializing, if not done
  unless Spawn.initDone?
    return Spawn.init null, => @run cb
  # wait till configuration is loaded
  if @constructor.configClass? and not @constructor.configClass.loaded
    return @constructor.configClass.load (err) =>
      return cb err if err
      @run cb
```

This will check the configuration and call the load method. If loading is already
in progress the new call will be attached to the event and get also notified if
it is loaded.

### Parent module

Now you may use this in the parent module or program:

``` coffee
run = (cb) ->
  # start initializing, if not done
  unless Test.initDone?
    return Test.init null, => @run cb
  # code running if initialized
  # ...
```

License
-------------------------------------------------

Copyright 2014-2015 Alexander Schilling

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

>  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
