Package: alinex-config
=================================================

[![Build Status](https://travis-ci.org/alinex/node-config.svg?branch=master)](https://travis-ci.org/alinex/node-config)
[![Coverage Status](https://coveralls.io/repos/alinex/node-config/badge.svg?branch=master)](https://coveralls.io/r/alinex/node-config?branch=master)
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

> It is one of the modules of the [Alinex Universe](http://alinex.github.io/code.html)
> following the code standards defined in the [General Docs](http://alinex.github.io/develop).


Install
-------------------------------------------------

[![NPM](https://nodei.co/npm/alinex-config.png?downloads=true&downloadRank=true&stars=true)
 ![Downloads](https://nodei.co/npm-dl/alinex-config.png?months=9&height=3)
](https://www.npmjs.com/package/alinex-config)

The easiest way is to let npm add the module directly to your modules
(from within you node modules directory):

``` sh
npm install alinex-config --save
```

And update it to the latest version later:

``` sh
npm update alinex-config --save
```

Always have a look at the latest [changes](Changelog.md).


Formats
-------------------------------------------------

This configuration class allows multiple formats to be used alternatively or combined.
So you may use the format you know best.

### File formats

See the [formatter](http://alinex.github.io/node-formatter) package for a detailed
description of the allowed formats and description of how to write them.

### RDBMS

> Not supported, yet.

| lastchange       | group | key          |  value | comment |
|------------------|-------|:-------------|:-------|:--------|
| 2014-12-11 19:45 | test  | rdbms        | null   | use an object |
| 2014-12-11 19:45 | test  | rdbms.name   | "name" | include a string |
| 2014-12-11 19:45 | test  | rdbms.list   | null   | and a list of numbers |
| 2014-12-11 19:45 | test  | rdbms.list[] | 1      |  |
| 2014-12-11 19:45 | test  | rdbms.list[] | 2      |  |
| 2014-12-11 19:45 | test  | rdbms.list[] | 3      |  |

### Object DB

> Not supported, yet.

Here, the JSON will be stored in the database like in the JSON file.


File Structure
-------------------------------------------------
As described above you can use different formats but you can also mix it or split your
configuration into multiple files.

So as an first example if you have a very large configuration of three major
parts you may split it up into 3 different files.

``` yaml
# config/server/http.yml
listen:
  ip: 192.168.0.1
  port: 80
```

``` yaml
# config/server/ftp.yml
listen:
  ip: 192.168.0.1
  port: 21
```

``` yaml
# config/server/mail.yml
pop:
  port: 110
imap:
  port: 143
```

And if the program now reads `config/**` you will get the combined structure:

``` yaml
server:
  http:
    listen:
      ip: 192.168.0.1
      port: 80
  ftp:
    listen:
      ip: 192.168.0.1
      port: 21
  mail:
    pop:
      port: 110
    imap:
      port: 143
```

This is because the config system will use the names behind the asterisk as
structure levels automatically but you may control the combination rules using
filter and path in the origin setup (see below).


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
config.register 'myapp', __dirname
# add a special path on the end (highest priority)
config.pushOrigin
  uri: 'file:///etc/my-config.yml'
# and add a schema to verify the database settings are correct
config.setSchema 'database',
  type: ....  # schema

# start initializing the configuration and load the data
config.init (err) ->
  return cb err if err
  # all configurations are loaded successfully
```

Alternatively you may skip your program with a detailed error message:

``` coffee
config.init (err) ->
  if err
    console.error "FAILED: #{err.message}"
    console.error err.description
    process.exit 1
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

> To don't mess with the names: I always address the instance with `config` and use
> a short name like `conf` for some data out of it.


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
/etc/myapp/*/*.yml      # find one level depth
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
- properties
- coffee
- javascript

But if you don't specify it, it will be auto detected based on the file extension
or the contents itself.

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
config.register myapp, __dirname,
  uri: '*.yml'
```

Like you see, you may also add the  attributes from the normal configuration
like `uri`, `filter` and `path`.

You may also register a module. Therefore give `null` as application name and
it will only add the first two paths based on the given directory.

If you won't have your settings in the 'config' folder you may specify another
one using `folder: "..."` as additional parameter.


Setup schema
-------------------------------------------------

The schema defines some validation and optimization rules which has to be
processed before using the values. If the validation fails it will return a
descriptive Error and don't use the values.

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


Access configuration
-------------------------------------------------

After everything is setup and loaded you may access the values or part of the
value tree. You always get a reference for performance reasons. So don't change
it's content.

``` coffee
conf = config.get()
```

Thats a simple call to get the complete data structure.


``` coffee
conf = config.get 'server'
conf = config.get 'database/master/address'
```

Or give an path to get only a subpart of the configuration.

``` coffee
if config.get('server')?
  # value found
```

And at last you may check that a specific part is set.


Web Services
-------------------------------------------------

Like using files you may also always use a web service to get the configuration.
But keep in mind that your system may not start if the web service is down.

It is as easy as using files:

``` coffee
config.pushOrigin
  uri: "http://echo.jsontest.com/key/value/one/two"
  path: 'echo'
```

This will result in the following configuration (after loaded via `init()`).

``` coffee
echo:
  one: 'two'
  key: 'value'
```

> Support for webservice formats like XML-RPC, JSON-RPC and SOAP may be integrated
> later. Also the support of possibilities to specify the concrete request may be
> extended on demand.


Examples
-------------------------------------------------

I often use the pattern of giving my modules two functions called setup() and init().
The setup() is first called to set up the basics like configuring the configuration
system.

``` coffee
# set the modules config paths and validation schema
setup = async.once this, (cb) ->
  # set module search path
  config.register false, fspath.dirname __dirname
  # add schema for module's configuration
  config.setSchema '/exec', schema, cb
```

The call of `async.once` will look that this method is only run one time (see
[Async](http://alinex.github.io/node-async).

Now you may add additional configuration paths...

``` coffee
# set the modules config paths, validation schema and initialize the configuration
init = async.once this, (cb) ->
  debug "initialize"
  # set module search path
  @setup ->
    return cb err if err
    config.init cb
```

The init() method now makes the system ready to use and if not up to date or
initialized will initialize the config system. The setup() is also called to make
it possible to call in one step if no special configuration is needed.


License
-------------------------------------------------

Copyright 2014-2016 Alexander Schilling

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

>  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
