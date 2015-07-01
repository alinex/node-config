chai = require 'chai'
expect = chai.expect
#require('alinex-error').install()

config = require '../../src/index'

init = (file, parser, cb) ->
  config.pushOrigin
    uri: "test/data/#{file}"
    parser: parser
  config.init cb

describe "Load", ->

  beforeEach ->
    # reset
    config.origin.shift() while config.origin.length
    config.schema =
      type: 'object'
    config.value = {}
    config.meta = {}
    config.listener = {}

  describe "path", ->

    it "should get all", (cb) ->
      config.pushOrigin
        uri: "test/data/format.yml"
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(d, 'yaml root').to.deep.equal
          format:
            yaml:
              string: 'test'
              longtext: 'And a long text with \' and " is possible, too'
              multiline: 'This may be a very long line in which newlines will be removed.\n'
              keepnewlines: 'Line 1\nLine 2\nLine 3\n'
              simplelist: '1, 2, 3'
              list: [ 'red', 'green', 'blue' ]
              person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

    it "should filter sublevel", (cb) ->
      config.pushOrigin
        uri: "test/data/format.yml"
        filter: 'format'
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(d, 'yaml root').to.deep.equal
          yaml:
            string: 'test'
            longtext: 'And a long text with \' and " is possible, too'
            multiline: 'This may be a very long line in which newlines will be removed.\n'
            keepnewlines: 'Line 1\nLine 2\nLine 3\n'
            simplelist: '1, 2, 3'
            list: [ 'red', 'green', 'blue' ]
            person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

    it "should filter multiple level depth", (cb) ->
      config.pushOrigin
        uri: "test/data/format.yml"
        filter: 'format/yaml'
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(d, 'yaml root').to.deep.equal
          string: 'test'
          longtext: 'And a long text with \' and " is possible, too'
          multiline: 'This may be a very long line in which newlines will be removed.\n'
          keepnewlines: 'Line 1\nLine 2\nLine 3\n'
          simplelist: '1, 2, 3'
          list: [ 'red', 'green', 'blue' ]
          person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

    it "should add path", (cb) ->
      config.pushOrigin
        uri: "test/data/format.yml"
        path: 'test'
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(d, 'yaml root').to.deep.equal
          test:
            format:
              yaml:
                string: 'test'
                longtext: 'And a long text with \' and " is possible, too'
                multiline: 'This may be a very long line in which newlines will be removed.\n'
                keepnewlines: 'Line 1\nLine 2\nLine 3\n'
                simplelist: '1, 2, 3'
                list: [ 'red', 'green', 'blue' ]
                person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

    it "should add multiple paths", (cb) ->
      config.pushOrigin
        uri: "test/data/format.yml"
        path: 'test/path'
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(d, 'yaml root').to.deep.equal
          test:
            path:
              format:
                yaml:
                  string: 'test'
                  longtext: 'And a long text with \' and " is possible, too'
                  multiline: 'This may be a very long line in which newlines will be removed.\n'
                  keepnewlines: 'Line 1\nLine 2\nLine 3\n'
                  simplelist: '1, 2, 3'
                  list: [ 'red', 'green', 'blue' ]
                  person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

    it.only "should use filter and path", (cb) ->
      config.pushOrigin
        uri: "test/data/format.yml"
        filter: 'format'
        path: 'test'
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(d, 'yaml root').to.deep.equal
          test:
            yaml:
              string: 'test'
              longtext: 'And a long text with \' and " is possible, too'
              multiline: 'This may be a very long line in which newlines will be removed.\n'
              keepnewlines: 'Line 1\nLine 2\nLine 3\n'
              simplelist: '1, 2, 3'
              list: [ 'red', 'green', 'blue' ]
              person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

#  describe.only "combine", ->
#  describe.only "validate", ->

