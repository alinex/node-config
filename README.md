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
config.search.push
  uri: 'file:///etc/my-config'
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
