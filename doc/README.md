# Alinex Config

This package will give you an easy way to load and use configuration settings in
your application or module.

Version 2 is a complete backward incompatible rewrite of the class. It has the goal
to make it compacter, faster and easier to use. The key concept is to do this steps as
a precompiler before starting the app, too. This allows the use of a small config access module
to import and access them.



This package will give you an easy way to load and use configuration settings in
your application or module in different ways.

You set up a schema out of the contained classes which allows to work with the
specific data structure. Then you can call the CLI to transform the configuration
files into pure JavaScript objects which now can be loaded using `import`.
But it is also possible to inject the values directly and to direct get the optimized
data structure instead of getting written down.

The major features are:
- allows different file formats
- supports validation
- supports modification rules
- can store optimized data structure as JavaScript module


Compiler methods:
- compiler.setup.configName = 'alinex'
- compiler.setup.schemaPath = 'dist/config'
- compiler.schema()
- compiler.find(schema)
- compiler.load(schema, path)
- compiler.validate(schema, data)
- compiler.write(schema, data)


Schema as class

    import * as Config from 'alinex-config'

    const server = new IntegerSchema({
      name: 'webserver',
      description: 'settings for the webserver component',      
    })

    server.add Schema

    exports default server



# Old concept

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

On demand you may also reload the configuration completely:

``` coffee
config.reload (err) ->
  if err
    console.error "FAILED: #{err.message}"
    console.error err.description
    process.exit 1
```

But if you want tp know in your app then some configuration was changed you can use
the path as an event which is fired if this element or one below is changed.

``` coffee
config.on '/address', ->
  console.log "New addresses found, reinit the list..."
  myList = config.get '/address'
```


Debugging
-------------------------------------------------
If you have any problems you may debug the code with the predefined flags. It uses
the debug module to let you define what to debug.

Call it with the DEBUG environment variable set to
- 'config' for basic information
- 'config:value' with structure after loaded
- 'config:access' with info about data accessed
- 'config*' for all of them

You can also combine them using comma or use only DEBUG=* to show all debug messages
of all modules.

Additional value checking will be done if the debugging for the general `config`
is enabled.


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
