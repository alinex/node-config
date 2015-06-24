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

Also see the last [changes](Changelog.md).


Install
-------------------------------------------------

The easiest way is to let npm add the module directly:

``` sh
npm install alinex-config --save
```

[![NPM](https://nodei.co/npm/alinex-config.png?downloads=true&stars=true)](https://nodei.co/npm/alinex-config/)


Usage
-------------------------------------------------

To use the configuration management you have to load the module first:

``` coffee
config = require 'alinex-config'
```

This gives you back the main configuration instance.
But before you can access your configuration you have to setup the system if not
already done and initialize it:

``` coffee
# register common configuration paths for application
config.register
  name: 'myapp'
# add a special path on the end (highest priority)
config.origin.push
  uri: 'file:///etc/my-config.yml'
# and add a schema to verify the database settings are correct
config.setSchema
  path: 'database'
  schema: ...

# start initializing the configuration and load the data
config.init (err) ->
  return cb err if err
  # all configurations are loaded successfully
```

Make sure that the initialization is completely done for all configuration data
before using it. If you change the setup later you have to reinit everything which
causes an extra afford which you should skip if possible.

After that is done you can easily access the configuration like:

``` coffee
conf = config.data
# here you have the whole registry data
conf = config.get 'server'
# and now you have only the server structure
conf = config.get 'database/master/address'
# or only a specific database connection
```

To don't mess with the names: I always address the instance with `config` and use
a short name like `conf` for some data out of it.


Setup origin
-------------------------------------------------

The origin is the place the configuration data comes from. For alinex-config you
have the possibility to specify multiple search paths, you can also overload
configurations with another file in higher priority and combine values from
different files together.
So the specification of the origin is the main part and is the base to build
the registry data.

### Origin Object

To setup the origin for the configuration module you have to extend the origin
list by adding a new origin object.

The single origin object describes where to find the configuration, what to use
and where to put them in the final data structure. It contains the following
possible elements:

- uri - pointing to the search
- parser - (optional) type to use for parsing the data
- filter - (optional) which part to use
- path - (optional) where to put it in the data structure

The following URI types are possible here:

- No Protocol => using the file protocol
- `file://` => load from local file
- `http://` or `https://` => load from web service

### File search

Access files absolute from root or relative from current directory:

``` text
file:///etc/myapp.yml   # absolute path
/etc/myapp.yml          # shortcut

file://config/myapp.yml # relative path
config/myapp.yaml       # shortcut
```

You can search by using asterisk as placeholder or a double asterisk to
go multiple level depth:

``` text
/etc/myapp.*            # search for any extension
/etc/myapp/*.yml        # find all files with this extension
/etc/myapp/*            # find all files in the directory
/etc/myapp/*/*.yml      # fin one level depth
/etc/myapp/**           # find all files in directory or subdirectories
/etc/myapp/**/*.yml     # find files in the directory or subdirectories
```

See more about the possible matchings at
[FS](http://alinex.github.io/node-fs/README.md.html#file%2Fpath%20matching).

### Parsing data

The data loaded from the given URI will be parsed if it is a string. You may
set one of the following parsers in `parser` to use:

- yaml
- json
- xml
- ini

But if you don't specify it, it will be auto detected based on the file extension
and the contents itself.

### Combine contents

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

### Origin Structure

The origin structure is a tree list which will be processed top down. This means
that you can add new origin objects at the top to use them as defaults or at
the end of the list to make this the highest priority.

In case of registering applications they will make a sublist with their search
paths (see below).

### Register Application

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
config.register myapp, __dirname, { uri: '*.yml' }
```


Setup schema
-------------------------------------------------

The second path is the schema which is used for validation and to sanitize
the values. This is done using a schema valid for the
[Validator](http://alinex.github.io/node-validator).


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


Access configuration
-------------------------------------------------


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
