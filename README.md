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

> It is one of the modules of the [Alinex Universe](http://alinex.github.io/code.html)
> following the code standards defined in the [General Docs](http://alinex.github.io/node-alinex).


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
So you may use the format you know best. The following table will give a short
comparison.

|   Format    | YAML | JSON | XML |  JS | CSON | INI | PROP | RDBMS | ObjDB |
|:------------|-----:|-----:|----:|----:|-----:|----:|-----:|------:|------:|
| Supported   |  yes |  yes | yes | yes |  yes | yes |  yes |    no |    no |
| Comments    |  yes | (yes)| yes | yes |  yes | yes |  yes |   yes | (yes) |
| Structure   |  yes |  yes | yes | yes |  yes | yes |  yes |   yes |   yes |
| Arrays      |  yes |  yes | yes | yes |  yes | yes |   no |   yes |   yes |
| Reloadable  |  yes |  yes | yes | yes |  yes | yes |  yes | (yes) | (yes) |
| Readiness   |  +++ |   ++ |   - |  ++ |  +++ |   + |    + |     + |    ++ |
| Calculations|   no |   no |  no | yes |  yes |  no |   no |    no |    no |
| Performance |   ++ |  +++ |   + | +++ |   ++ |  ++ |    + |     - |     + |
| Common      |   ++ |    + |  ++ |  -- |  --- | +++ |  +++ |     - |    -- |

### YAML

This is a simplified and best human readable language to write structured
information. See some examples at [Wikipedia](http://en.wikipedia.org/wiki/YAML).

Common file extensions `yml` or `yaml`.

__Example__

title: YAML Test

``` yaml
# include text elements
text: test

# commas, colons and brackets has to be in quotes
longtext: "And a long text with ' and "" is possible, too"

# multiline text with newlines removed
multiline: >
  This may be a very long
  line in which newlines
  will be removed.

# and now the newlines are kept
keepnewlines: |
  Line 1
  Line 2
  Line 3

# and some lists
simplelist: 1, 2, 3
list:
  - red
  - green
  - blue

# an sub object
person:
  name: Alexander Schilling
  job: Developer
```

### JSON

This format uses the javascript object notation a human readable structure. It
is widely used in different languages not only JavaScript. See description at
[Wikipedia](http://en.wikipedia.org/wiki/Json).

Common file extension `json`.

``` json
{
  "string": "test",
  "list": [1, 2, 3],
  "person": {
    "name": "Alexander Schilling",
    "job": "Developer"
  }
}
```

JSON won't allow comments but you may use JavaScript like comments using
`//` and `/*...*/` like known in javascript. Therefore use the javascript
parsing.

### JavaScript

Also allowed are normal JavaScript files. In comparison to the JSON format it
is more loosely so you may use single quotes, keys don't need quotes at all and
at last you may use calculations. But you may only access elements in the same
file accessing data from outside is prevented by security.

Common file extension `js`.

``` javascript
{
  // include a string
  string: "test",

  // and a list of numbers
  list: [1, 2, 3],

  // add a sub object
  person: {
    name: "Alexander Schilling",
    job: "Developer"
  },

  // calculate session timeout in milliseconds
  session: 15*60*1000,
  calc: Math.sqrt(16)
}
```

### CSON

Like above you may write the modules in CoffeeScript like in JSON.

Common file extension `cson`.

``` coffee
# include a string
string: "test"

# and a list of numbers
list: [
  1
  2
  3
]

# add a sub object
person:
  name: "Alexander Schilling"
  job: "Developer"

# calculate session timeout in milliseconds
session: 15*60*1000
calc: Math.sqrt 16
```

### XML

The XML format should only use Tags and values, but no arguments.

Common file extension `xml`.

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

  <!-- sub object -->
  <person>
    <name>Alexander Schilling</name><job>Developer</job>
  </person>

  <!-- cdata section -->
  <cdata><![CDATA[i\'m not escaped: <xml>!]]></cdata>

  <!-- using attributes -->
  <attributes type="detail">
    Hello all together
  </attributes>

</xml>
```

### INI

This is one of the oldest formats used for configurations. It is very simple but
allows also complex objects through extended groups.

Common file extension `ini`.

``` ini
; put everything in a main group
[ini]
string = test

; add a simple list
list[] = 1
list[] = 2
list[] = 3

; add a sub object
[ini.person]
name = Alexander Schilling
job = Developer
```

### PROPERTIES

Mainly in the Java world properties are used to setup configuration values.
But it won't have support for arrays, you only may use objects with numbered keys.

``` properties
# put everything in a main group
prop.string = test

! add a simple list
prop.list.1 = 1
prop.list.2 = 2
prop.list.3 = 3

! add a sub object
prop.person.name : Alexander Schilling
prop.person.job: Developer
```

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
  basedir: __dirname
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
config.register
  name: myapp
  basedir: __dirname
  uri: '*.yml'
```

Like you see, you may use the keys:

- name - short name of the application
- basedir - base directory of the application

In addition all attributes from the normal configuration like `uri` and so on
are also possible.


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
