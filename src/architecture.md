Architecture
==================================================
The configuration handling consists of a singleton class as central information
storage like a registry. On access you will get references to the data.

A special behavior is the reloading of the configuration after the files
changed. This is done using a watcher on the file search path which will
automatically load all configurations which are changed into the class cache.
Through class events the instances will get informed if anything changed, so
they can reload their data and emit events for their application listeners
to update this data, too.
