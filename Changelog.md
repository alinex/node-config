Version changes
=================================================

The following list gives a short overview about what is changed between
individual versions:

Version 0.4.4 (2015-03-20)
-------------------------------------------------
- Added real life example to use.
- Added get() in the API doc.
- Make debug output correct with ~ path.

Version 0.4.3 (2015-03-17)
-------------------------------------------------
- Resolve homedir in platform agnostic way.
- Fixed chokidar versions.

Version 0.4.2 (2015-03-16)
-------------------------------------------------
- Allow also lower versions of chokidar.

Version 0.4.1 (2015-03-16)
-------------------------------------------------
- 

Version 0.4.0 (2015-03-14)
-------------------------------------------------
- Add new node versions to travis checks.
- Upgraded dependend packages.
- Added test case for new get method.
- Add the get() method for quick access.
- Small fixes.
- Updated documentation.
- Update API documentation for new version.
- Fixed code to work with new coffeescript version.
- Update documentation structure.
- Update documentation structure.
- Print debug values not before they are validated.

Version 0.3.4 (2014-12-30)
-------------------------------------------------
- Disable watching per default and support enabling it per each instance.

Version 0.3.3 (2014-12-11)
-------------------------------------------------
- Extended documentation and optimized internal listener handling.
- Fixed double callbacks on reload.
- Set event listeners high but not too high.
- Fixed reload problems
- Changed sort order if using multiple config files.
- Allow softlinks in configuration paths.
- Added error message if no config file could be found.
- Better display of loaded config in debug mode.
- Changed alinex-util to dependency.

Version 0.3.2 (2014-12-04)
-------------------------------------------------
- Adding debug entry to display loaded values.
- Optimized reloading of values.
- Don't output config settings on debug.
- Set debug message if config loaded successfully.
- Integrated travis and coveralls tracking.
- Fixed bug in not sending errors back if load called multiple times.
- Small fix of unneccessary call.
- Fixed package.json version notation.

Version 0.3.1 (2014-10-08)
-------------------------------------------------
- Upgraded chokidar submodule.
- Small optimization in event callbacks.
- Fixed default value handling.
- Rename method addCheck -> setCheck
- Updated code documentation.
- Updated validator dependency.
- Redesign to be more robust for concurrent access.
- Reenable watch feature.
- Remove watch option till further tested.

Version 0.3.0 (2014-09-17)
-------------------------------------------------
- Updated debug to 2.0.0
- Changed .gitignore.
- Upgraded to validator 0.2.
- Fixed calls to new make tool.
- Updated to alinex-make 0.3 for development.
- Merge branch 'master' of https://github.com/alinex/node-config
- Added support for auto reloading of configurations.
- Prepend 'config' to the source names for checks.
- Don't include directories in find.
- Merge branch 'master' of https://github.com/alinex/node-config
- Addded documentation for validator integration.
- Added alinex-validator support.
- Updated changelog.

Version 0.2.2 (2014-08-01)
-------------------------------------------------
- Made usage of checks for subgroup more clear in documentation.
- Added find() to search for config files.
- Added possibility to retrieve instance in callback of constructor.
- Added file-type constraint for file search.
- Fixed typo in documentation example.
- Fixed spellcheck error in documentation.
- Merge branch 'master' of https://github.com/alinex/node-config
- Added documentation to run checks on subgroup.
- Support 'change' event on Class.events and config instance.
- Updated documentation.
- Small code restructuring.
- Changed some inline comments.
- Let initialization also work if check failed.
- Removed alinex-error integration in productive code.

Version 0.2.1 (2014-07-18)
-------------------------------------------------
- Added support for events.
- Small typo fixes.

Version 0.2.0 (2014-07-16)
-------------------------------------------------
- Add tests for optimization checks.
- Added test for preloading values before check.
- Added support for xml configuration.
- Fixed checks to succeed or fail correctly.
- Fixed syntax errors in code.
- Added checks for validation and manipulation.
- Adding support for default values.
- Document the overloading order.

Version 0.1.0 (2014-07-11)
-------------------------------------------------
- Added support for JavaScript and CoffeeScript files.
- Changed syntax to access instance properties without function.
- Made base structure with YAML loading working.
- Added untested code for reading files.
- Base structure partly running.
- Changed structure with static data storage.
- Restructure into classes.
- Added mocha test.
- Initial commit

