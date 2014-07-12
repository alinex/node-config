Package: alinex-config
=================================================

[![Build Status] (https://travis-ci.org/alinex/node-config.svg?branch=master)](https://travis-ci.org/alinex/node-config) 
[![Coverage Status] (https://coveralls.io/repos/alinex/node-config/badge.png?branch=master)](https://coveralls.io/r/alinex/node-config?branch=master)
[![Dependency Status] (https://gemnasium.com/alinex/node-config.png)](https://gemnasium.com/alinex/node-config)

This package will give you an easy way to load and use configuration settings in 
your application or module.

It will read named files in different formats (YAML, JSON, JavaScript, CoffeeScript) 
and supports validation and optimization/completion. Also the configuration will 
automatically be updated on changes in the file system and may inform it's 
dependent objects.


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
specified in the global variabl `ROOT_DIR`. See more about the
[Alinex File Structure](http://alinex.github.io/node-alinex/src/doc/filestructure.md.html)

Now you have to instantiate a new Config instance and have the settings as
properties for easy access:

    config = new Config('server', function() {
      // ...
      if (config.url) {
        console.log('Started at '+config.url);
      }
    });

The asynchronous creation of an instance will load and import the settings. It
will look for files in each directory in the search path, which have the given
name (in the example above 'server') or start with it and at least a following 
dash sign:

- server.yml
- server.jason
- server-part1.yml
- server-part2.yml


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


Configuration File Formats
-------------------------------------------------

This config class allows multiple formats to be used alternatively or combined.
So you may use the format you know best.

### YAML

This is a simplified and best human readable language to write structured
information. See some examples at [Wikipedia](http://en.wikipedia.org/wiki/YAML).

Use the file extensions `yml` or `yaml`.

### JSON

This format uses the javascript object notation a human readable structure. It
is widely used in different languages not only JavaScript. See description at
[Wikipedia](http://en.wikipedia.org/wiki/Json).

JSON won't allow comments but you may use JavaScript like comments using
`//` and `/*...*/` like known in javascript. They will be removed before 
interpreting the file contents.

Use the file extension `json`.

### JavaScript

Also allowed are normal JavaScript modules like done in node.js. The module must
export the configuration object. 

Use the file extension `js`.

### CoffeeScript

Like above you may write the modules in CoffeeScript.

Use the file extension `coffee`.


Default values
-------------------------------------------------

It is possible to set default values for each configuration on the class.

    Config.default = { server: { url: 'http://localhost' } };

This will be set if not overwritten in any configuration file for the `server`
configuration.


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
