Alinex Config: Readme
=================================================

[![GitHub watchers](
  https://img.shields.io/github/watchers/alinex/node-config.svg?style=social&label=Watch&maxAge=2592000)](
  https://github.com/alinex/node-config/subscription)<!-- {.hidden-small} -->
[![GitHub stars](
  https://img.shields.io/github/stars/alinex/node-config.svg?style=social&label=Star&maxAge=2592000)](
  https://github.com/alinex/node-config)
[![GitHub forks](
  https://img.shields.io/github/forks/alinex/node-config.svg?style=social&label=Fork&maxAge=2592000)](
  https://github.com/alinex/node-config)<!-- {.hidden-small} -->
<!-- {p:.right} -->

[![npm package](
  https://img.shields.io/npm/v/alinex-config.svg?maxAge=2592000&label=latest%20version)](
  https://www.npmjs.com/package/alinex-config)
[![latest version](
  https://img.shields.io/npm/l/alinex-config.svg?maxAge=2592000)](
  #license)<!-- {.hidden-small} -->
[![Travis status](
  https://img.shields.io/travis/alinex/node-config.svg?maxAge=2592000&label=develop)](
  https://travis-ci.org/alinex/node-config)
[![Coveralls status](
  https://img.shields.io/coveralls/alinex/node-config.svg?maxAge=2592000)](
  https://coveralls.io/r/alinex/node-config?branch=master)
[![Gemnasium status](
  https://img.shields.io/gemnasium/alinex/node-config.svg?maxAge=2592000)](
  https://gemnasium.com/alinex/node-config)
[![GitHub issues](
  https://img.shields.io/github/issues/alinex/node-config.svg?maxAge=2592000)](
  https://github.com/alinex/node-config/issues)<!-- {.hidden-small} -->

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

> It is one of the modules of the [Alinex Namespace](https://alinex.github.io/code.html)
> following the code standards defined in the [General Docs](https://alinex.github.io/develop).

__Read the complete documentation under
[https://alinex.github.io/node-config](https://alinex.github.io/node-config).__
<!-- {p: .hidden} -->


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


Sources / File Formats
-------------------------------------------------

This configuration class allows multiple formats to be used alternatively or combined.
So you may use the format you know best. See the
{@link alinex-format/src/type/index.md alinex-format} package for a detailed
description of the allowed formats and description of how to write them.

As described in the link above you can use different formats but you can also
split your configuration into multiple files and use different formats in each of
them.

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


Other file formats
-------------------------------------------------

Beside configuration files you may also access templates or other user changeable
files in the same manner using such an search path.

Therefore you have to register an app with a type:

``` coffee
config.register 'alinex', null,
  folder: 'template'
  type: 'template'
```

And later you may get all the possible files:

``` coffee
config.typeSearch 'template', (err, map) ->
  console.log err, map
```


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

(C) Copyright 2014-2016 Alexander Schilling

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

>  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
