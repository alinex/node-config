Version changes
=================================================

The following list gives a short overview about what is changed between
individual versions:

Version 1.4.2 (2017-03-27)
-------------------------------------------------
- Update alinex-util@2.5.1, async@2.2.0, debug@2.6.3, request@2.81.0, alinex-builder@2.4.1, deasync@0.1.9
- Fix missing callback after revalidation.
- Debug schema values in sublevel config:values.
- Update some dependencies.
- Fix documentation to hide style comments in github view.
- Optimize debugging output.
- Optimize debugging output.
- Add title for validating on debug.
- Extend example in documentation.

Version 1.4.1 (2016-10-18)
-------------------------------------------------
- Optimize event list creation only for events there listeners are available.
- Try to find bug in validation.
- Fix travis config.

Version 1.4.0 (2016-10-17)
-------------------------------------------------
Added events to listen on changes while reloading.

- Update events documentation.
- Fire events after change.
- Describe usage of new event logic.
- Document debugging.

Version 1.3.0 (2016-10-14)
-------------------------------------------------
- Update async@2.1.1.
- Check origin schema in debug mode.
- Optimize debug calls.
- Update internal documentation of loader.
- Finish Documentation of API Usage.
- Update setup documentation.
- Describe architecture.
- Restructure doc pages.
- Update docs.
- Fixed test to also work on travis.
- Fix documentation link.
- Remove uglify compression from build.
- Fix file find calls to support new module version.
- Replace alinex-formatter with alinex-format.
- Update async@2.0.1, alinex-util@2.4.2, request@2.75.0, alinex-builder@2.3.8, alinex-fs@3.0.3, alinex-validator@2.0.1
- Update travis checks.
- Rename links to Alinex Namespace.
- Add copyright sign.

Version 1.2.1 (2016-07-09)
-------------------------------------------------
- Always add alinex app for template search.

Version 1.2.0 (2016-07-09)
-------------------------------------------------
Added support for other file formats.

- Allow use of search path for other file formats.
- Use general search path alinex.

Version 1.1.6 (2016-06-02)
-------------------------------------------------
- Upgraded validator for new handlebars-helper.

Version 1.1.5 (2016-06-02)
-------------------------------------------------
- Upgraded  validator and builder packages.

Version 1.1.4 (2016-05-17)
-------------------------------------------------
Changed config parser which supports more formats but changed some minor parts of xml parsing.

- 

Version 1.1.3 (2016-05-16)
-------------------------------------------------
Changed config parser which supports more formats but changed some minor parts of xml parsing.

- Use formatter package instead own implementation.
- Small code style optimization.

Version 1.1.2 (2016-05-02)
-------------------------------------------------
This brings the nobr handlebar helpers in to be used.

- Upgraded validator and builder.
- Added v6 for travis but didn't activate, yet.

Version 1.1.1 (2016-04-29)
-------------------------------------------------
- Upgraded to raw async 2.0 and builder 2.0.

Version 1.1.0 (2016-04-21)
-------------------------------------------------
- Use new extend and clone methods.
- Upgraded util and validator package - BREAKING CHANGES in handlebars templates.
- Upgraded util, yaml and request package.

Version 1.0.19 (2016-04-15)
-------------------------------------------------
- Upgraded validator and request.

Version 1.0.18 (2016-04-11)
-------------------------------------------------
- Updated validator for fix in datetime lib.

Version 1.0.17 (2016-04-08)
-------------------------------------------------
- Upgraded package validator.

Version 1.0.16 (2016-04-08)
-------------------------------------------------
- Upgraded packages util, validator and request.

Version 1.0.15 (2016-03-31)
-------------------------------------------------
- Upgraded validator package.

Version 1.0.14 (2016-03-21)
-------------------------------------------------
- Upgraded validator, util, yaml and builder.
- Fixed general link in README.
- Updated inline documentation.

Version 1.0.13 (2016-02-26)
-------------------------------------------------
- Upgrade validator.

Version 1.0.12 (2016-02-10)
-------------------------------------------------
- Updated validator to support handlebars with international dates.

Version 1.0.11 (2016-02-04)
-------------------------------------------------
- Updated subpackages to newest versions.
- updated ignore files.
- Move optional dependencies to normal.
- Added missing packages for ini and properties format.

Version 1.0.10 (2016-02-03)
-------------------------------------------------
- Added missing validator.
- Fixed style of test cases.
- Fixed lint warnings in code.
- Updated meta data of package and travis build versions.
- Upgraded some subpackages.

Version 1.0.9 (2016-02-01)
-------------------------------------------------
- Now allow newest validator version again.

Version 1.0.8 (2016-02-01)
-------------------------------------------------
- Prevent newest validator version (buggy build).
- Optimized debug output.
- Example for error output.
- Add debug entry for registering urls.

Version 1.0.7 (2015-10-21)
-------------------------------------------------
- Remove only keys.
- Fixed bug in default folder name.
- Add the ability to change config folder.

Version 1.0.6 (2015-09-22)
-------------------------------------------------
- Fix path resolve, which leads to wrong main name.

Version 1.0.5 (2015-09-03)
-------------------------------------------------
- Use other url for web tests.
- Use other url for web tests.
- Fixed test timeouts.
- Fixed use of config filename in config.
- Remove debug output through console.log.
- Fix auto path generation for direct file load.
- Optimize direct file load and fix error output in debug mode.
- Don't use index as path.

Version 1.0.4 (2015-08-19)
-------------------------------------------------
- Add example for splitted configuration.
- Fix automatic path addition to structure which had the filename two times.
- Add example for using config in modules.
- Start adding ssh support.
- Added error messages if file parsing failed completely.

Version 1.0.3 (2015-07-10)
-------------------------------------------------
- Fixed register() to work for modules - was doing nothing.

Version 1.0.2 (2015-07-09)
-------------------------------------------------
- Use onceTime() to run the init method not simultaneously.
- Remove check for if nothing found because it is allowed.
- Allow init() to be called anytime also if not sure if it is already done.
- Merge branch 'master' of https://github.com/alinex/node-config
- Add coverage badge.

Version 1.0.1 (2015-07-07)
-------------------------------------------------
- Allow register() to be used for modules, too.

Version 1.0.0 (2015-07-04)
-------------------------------------------------
- Added paging for blog posts.
- Added test for web load.
- Remove old code.
- Fixed access of subpath.
- Fixed non-existent directory to not throw error.
- Testet register method.
- Added get() for accessing and rehister().
- Fixed tests because of test file renames.
- Fixed validation and test file search and loading.
- Added setSchema() method with validation.
- Tested validation.
- Finished filter and path settings.
- Add properties file support.
- Finished parsing of xml with cdata and attributes.
- Added lookup table by extensions to speed up config format detection.
- Fixed and tested formats yaml, ja, javascript, json, coffee.
- Merge branch 'master' of https://github.com/alinex/node-config
- Add path from file directory and name.
- Combine all configuration origins together with filter and path.
- Added possibility to load config over web service.
- Optimized code style.
- Added stub for filtering.
- Added travis-ci.
- Updated insstall documentation.
- Added ini support and meta collections.
- Update planning document.
- Enabled search in filesystem, load and parse files.
- Updated planing structure.
- Updated planing mindmap.
- Describe setup procedure.
- Restart code for new major version.
- Made badge links npm compatible in documentation.
- Added planing mindmap.
- Remove io.js from travis tests.
- Add coveralls.
- Structure change of package.json.
- Updated some minor issues.

Version 0.4.5 (2015-03-20)
-------------------------------------------------
-

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
