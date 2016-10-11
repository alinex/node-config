Architecture
==================================================
The configuration handling consists of a singleton class as central information
storage like a registry. On access you will get references to the data.

$$$ plantuml {.right}
  participant app
  participant config
  database registry
  database file
  participant format
  participant validator

  == Startup ==
  app  -> config : require
  activate config #LightSalmon
  app  -> config : setup(...)
  app  -> config : init(cb)
  activate config
  config  -> file : find + load
  config  -> format : parse
  config  -> validator : check and optimize
  config  -> config : combine
  config --> registry : store
  app <-- config : ok
  deactivate config
  == Use ==
  app  -> config : get(name)
  config  -> registry : read
  app <-- registry : data

  hide footbox
$$$

The most things are done while starting up your application (app). You will load
the config module and setup the config module with the file storage and validation
schema, first. When you call the `init()` method it will initialize everything. This
is the heaviest process because it will search for the configuration files, load
them, parse them and validate the resulting structure with the schema given in the
setup.

After that step the config module keeps the ready to use registry. If you query it
using the `get()` method it will do no less than retrieve the data on the defined path.
So it's very fast now.

A special behavior is the reloading of the configuration after the files
changed. This can be triggered using the `reload()` method which will run the
whole process from the initializing again and on the end replaces the current
configuration with the new one. You can do this in the asynchronously in the background.
To get your application parts be notified then to update the possible changed data
you can use the event listener interface.
