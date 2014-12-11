Package: alinex-config
=================================================

[![Build Status] (https://travis-ci.org/alinex/node-config.svg?branch=master)](https://travis-ci.org/alinex/node-config)
[![Coverage Status] (https://coveralls.io/repos/alinex/node-config/badge.png?branch=master)](https://coveralls.io/r/alinex/node-config?branch=master)
[![Dependency Status] (https://gemnasium.com/alinex/node-config.png)](https://gemnasium.com/alinex/node-config)

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

    > npm install alinex-config --save

[![NPM](https://nodei.co/npm/alinex-config.png?downloads=true&stars=true)](https://nodei.co/npm/alinex-config/)


Usage
-------------------------------------------------

To easily make your module configurable you need to load the class first:

    var Config = require('alinex-config');

To configure where to look for files you may give a list of directories:

    Config.search = ['var/src/config', 'var/local/config'];

If nothing specified it will search in the above directories under the directory
specified in the global variable `ROOT_DIR`. See more about the
[Alinex File Structure](http://alinex.github.io/node-alinex/src/doc/filestructure.md.html)

To load a specific configuration you have to instantiate it with it's name. The
factory method will help to only have one instance per each configuration name.

    var config = Config.instance('server');

Alternatively you may create a new isolated instance, which is mostly necessary
if you have the same name but in another path being used separately.

    var config = new Config('server');

Therefore you may specify a special search path:

    config.search = ['var/src/config', 'var/local/config'];

Before using it you now have to load the configuration. That will be started
after calling `load`. After that you got the settings as properties for easy
access.

    config.load(function(err, data) {
      if (err) {...}
      // ...
      if (config.data.url) {
        console.log('Started at '+config.data.url);
      }
    });

To make accessing of the config values shorter you may also use:

    config.load(function(err, data) {
      if (err) {...}
      config = data;
      // ...
      if (config.url) {
        console.log('Started at '+config.url);
      }
    });



API
-------------------------------------------------

### Class configuration

- [Config.search](src/index.coffee#search) - to set the search path
- `Config.watch` (boolean) - set to false to disable reloading

### Static calls

- [Config.find()](src/index.coffee#find configuration files) - to search for
  existing configuration files
- [Config.instance()](src/index.coffee#factory) - to get a config instance

### Instances

- [new Config()](src/index.coffee#create instance) - to create a new config
  instance
- [config.default](src/index.coffee#default values) - to set the default values
- [config.addCheck](src/index.coffee#add check function) - to validate or
  optimize the values
- values are directly accessible

### Instance Events

The following events are supported:

- `error` - then something fails (with message as data)
- `change` - the instance data has changed after loading


Search and order
-------------------------------------------------

Configurations are searched in all supported file formats under the given
directories and below.

You may also subdivide the configuration in multiple parts like (maybe also with
mixed formats):

- server.yml
- server-part1.yml
- server-part2.yml

The order is essential because the later file will overwrite the same keys of
the earlier ones. So the order looks like:

1. Use each directory in given search list order
2. Use files with only base names
3. Use the partial extensions in alphabetical order


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


### JSON

This format uses the javascript object notation a human readable structure. It
is widely used in different languages not only JavaScript. See description at
[Wikipedia](http://en.wikipedia.org/wiki/Json).

JSON won't allow comments but you may use JavaScript like comments using
`//` and `/*...*/` like known in javascript. They will be removed before
interpreting the file contents.

Use the file extension `json`.

    {
      // use an object
      "json": {
        // include text elements
        "name": "test",
        // and a list of numbers
        "list": [1, 2, 3]
      }
    }


### XML

The XML format should only use Tags and values, but no arguments.

Use the file extension `xml`.

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

### JavaScript

Also allowed are normal JavaScript modules like done in node.js. The module must
export the configuration object.

Use the file extension `js`.

    module.exports = {
      // use an object
      javascript: {
        // include a string
        name: "test",
        // and a list of numbers
        list: [1, 2, 3]
      }
    }

### CoffeeScript

Like above you may write the modules in CoffeeScript.

Use the file extension `coffee`.

    module.exports =
      # use an object
      coffee:
        # include a string
        name: "test"
        # and a list of numbers
        list: [1, 2, 3]

### Ini file

Not supported, yet.

    ; use an object
    ; include a string
    ini.name = test
    ; and a list of numbers
    ini.list[] = 1
    ini.list[] = 2
    ini.list[] = 3

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

    Config.default = { server: { url: 'http://localhost' } };

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

    Config.addCheck('server', {
      title: "Testfile"
      description: 'the structure used to demonstrate here'
      check: 'type.string'
      maxLength: 25
    }, function(err) {
      // may get an error if values already loaded
    });

### Check function

With the check function you may define what you want, but you also can combine
it with the validator.

    function myCheck(name, values, cb) {
      // change or check the values
      // ...
      // on error call cb('something is not ok');
      cb();
    }
    Config.addCheck('server', myCheck, function(err) {
      // may get an error if values already loaded
    });

The `name` here is the name of the configuration which may be used in reporting.
The `values` maybe changed.

If an error is returned it will also be returned while adding the check or within
the constructor. But it won't stop the processing. You may also throw an error
to really stop if a check failed.

This checks have to be added to the Config class using `Config.addCheck(name, check):`

### Predefined checks

Classes or functions which support this module often has predefined checks
to be used.

    Config.addCheck('server', AnyClass.check, function(err) {
      // may get an error if values already loaded
    });

But if the configuration for AnyClass is only a subgroup of a bigger configuration
file you have to wrap the call in an additional function:

    // the wrapper function
    function myCheck(name, values, cb) {
      // change the name to reflect change in reporting
      // call it with the subgroup
      AnyClass.check(name+'.anygroup', values.anygroup, cb);
    }
    Config.addCheck('server', myCheck, function(err) {
      // may get an error if values already loaded
    });

### Using alinex-validator

A very easy way to do validations is through the
[https://alinex.github.io/node-validator](alinex-validator) module. It let's
you define your validation rules as rule structure in an object.

    Config.addCheck(function(name, values, cb) {
      return validator.check(name, values, {
        type: 'type.integer',
        options: {
          min: 0,
          max: 100
        }
      }, cb);
    });

That's the way most alinex modules implement their own check methods.


Working with events
-------------------------------------------------
While the configuration may change you should listen to the `change` event which
will inform for any change in the current configuration. Now you have to reinit
everything which changed.

Keep in mind to alway unregister event listeners while no longer used to prevent
memory leaks.

An example might look like:

    // create two listener methods
    var sendError = function(err) {
      config.removeListener('change', sendChange);
      // do something....
    };
    var sendChange = function() {
      config.removeListener('error', sendError);
      // do something....
    };

    // start listening
    config.once('error', sendError);
    config.once('change', sendChange);


Submodule pattern
-------------------------------------------------

To make configuration work through a complex system of program, modules and
submodules the following pattern may help. (For better overview the example is
written in coffee script)

### Submodule

In the module you load the configuration class and make an init method which is used
to start loading the configuration.

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

This method can consume different informations:

- a string specifying the configuration file
- a already configured `Config` instance
- an object holding all the configuration values

And when the configuration is needed in example in an run method:

    run: (cb) ->
      # start initializing, if not done
      unless Spawn.initDone?
        return Spawn.init null, => @run cb
      # wait till configuration is loaded
      if @constructor.configClass? and not @constructor.configClass.loaded
        return @constructor.configClass.load (err) =>
          return cb err if err
          @run cb

This will check the configuration and call the load method. If loading is already
in progress the new call will be attached to the event and get also notified if
it is loaded.

### Parent module

Now you may use this in the parent module or program:

    run = (cb) ->
      # start initializing, if not done
      unless Test.initDone?
        return Test.init null, => @run cb
      # code running if initialized
      ...


License
-------------------------------------------------

Copyright 2014 Alexander Schilling

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

>  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
