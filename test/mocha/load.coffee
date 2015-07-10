chai = require 'chai'
expect = chai.expect
fspath = require 'path'
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

  describe "file", ->

    it "should work", (cb) ->
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
              simplelist: [1, 2, 3]
              list: [ 'red', 'green', 'blue' ]
              person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

    it "should work if one origin missing", (cb) ->
      config.pushOrigin
        uri: "test/data/not-here.yml"
      config.pushOrigin
        uri: "test/data/format.yml"
      config.pushOrigin
        uri: "test/data/not-here.xml"
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
              simplelist: [1, 2, 3]
              list: [ 'red', 'green', 'blue' ]
              person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

    it "should work if one directory is missing", (cb) ->
      config.pushOrigin
        uri: "test/not-here/*"
      config.pushOrigin
        uri: "test/data/format.yml"
      config.pushOrigin
        uri: "not-here/test/format.xml"
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
              simplelist: [1, 2, 3]
              list: [ 'red', 'green', 'blue' ]
              person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

    it "should load directory", (cb) ->
      config.pushOrigin
        uri: "test/data/*"
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(Object.keys d.format, 'main keys').to.deep.equal [
          'coffee'
          "ini"
          "javascript"
          "json"
          "prop"
          "xml"
          'yaml'
        ]
        cb()

    it "should load multiple files", (cb) ->
      config.pushOrigin
        uri: "test/data/*.xml"
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(Object.keys d, 'main keys').to.deep.equal [
          'format'
          'link'
        ]
        cb()

  describe "path", ->

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
            simplelist: [1, 2, 3]
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
          simplelist: [1, 2, 3]
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
                simplelist: [1, 2, 3]
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
                  simplelist: [1, 2, 3]
                  list: [ 'red', 'green', 'blue' ]
                  person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

    it "should use filter and path", (cb) ->
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
              simplelist: [1, 2, 3]
              list: [ 'red', 'green', 'blue' ]
              person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

  describe "combine", ->

    it "should merge different data", (cb) ->
      config.pushOrigin
        uri: "test/data/format.yml"
        filter: 'format'
      config.pushOrigin
        uri: "test/data/format.xml"
        filter: 'format'
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(d, 'yaml+xml root').to.deep.equal
          yaml:
            string: 'test'
            longtext: 'And a long text with \' and " is possible, too'
            multiline: 'This may be a very long line in which newlines will be removed.\n'
            keepnewlines: 'Line 1\nLine 2\nLine 3\n'
            simplelist: [1, 2, 3]
            list: [ 'red', 'green', 'blue' ]
            person: { name: 'Alexander Schilling', job: 'Developer' }
          xml:
            name: 'test',
            list: [ '1', '2', '3' ]
            person: { name: 'Alexander Schilling', job: 'Developer' }
            cdata: 'i\\\'m not escaped: <xml>!'
            attributes: { value: '\n    Hello all together\n  ', type: 'detail' }
        cb()

    it "should merge together data", (cb) ->
      config.pushOrigin
        uri: "test/data/format.yml"
        filter: 'format/yaml'
      config.pushOrigin
        uri: "test/data/format.xml"
        filter: 'format/xml'
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(d, 'yaml+xml root').to.deep.equal
          string: 'test'
          name: 'test',
          longtext: 'And a long text with \' and " is possible, too'
          multiline: 'This may be a very long line in which newlines will be removed.\n'
          keepnewlines: 'Line 1\nLine 2\nLine 3\n'
          simplelist: [1, 2, 3]
          list: [ 'red', 'green', 'blue', '1', '2', '3' ]
          person: { name: 'Alexander Schilling', job: 'Developer' }
          cdata: 'i\\\'m not escaped: <xml>!'
          attributes: { value: '\n    Hello all together\n  ', type: 'detail' }
        cb()

    it "should merge (overwrite) data", (cb) ->
      config.pushOrigin
        uri: "test/data/format.xml"
        filter: 'format/xml'
      config.pushOrigin
        uri: "test/data/format.yml"
        filter: 'format/yaml/person'
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(d, 'yaml+xml root').to.deep.equal
          name: 'Alexander Schilling'
          job: 'Developer'
          list: [ '1', '2', '3' ]
          person: { name: 'Alexander Schilling', job: 'Developer' }
          cdata: 'i\\\'m not escaped: <xml>!'
          attributes: { value: '\n    Hello all together\n  ', type: 'detail' }
        cb()

  describe "register", ->

    it "should combine all data for module", (cb) ->
      config.register null, fspath.resolve __dirname, '../data/app'
      # test
      config.init (err) ->
        expect(err, 'error').to.not.exist
        expect(config.origin[0].length, 'first origin entry length').to.be.equal 2
        d = config.value
        expect(d, 'yaml+xml root').to.deep.equal
          register:
            data1: "local"
            data2: "local"
            data3: "local"
            data4: "src"
            local: "local position"
            src: "source position"
        cb()

    it "should combine all data for apps", (cb) ->
      config.register 'XXXXX', fspath.resolve __dirname, '../data/app'
      # fix user and global settings
      config.origin[0][2].uri = config.origin[0][2].uri.replace '/etc/XXXXX', fspath.resolve __dirname, '../data/app/global'
      config.origin[0][3].uri = config.origin[0][3].uri.replace /.*?\.XXXXX/, fspath.resolve __dirname, '../data/app/user'
      # test
      config.init (err) ->
        expect(err, 'error').to.not.exist
        expect(config.origin[0].length, 'first origin entry length').to.be.equal 4
        d = config.value
        expect(d, 'yaml+xml root').to.deep.equal
          register:
            data1: "user"
            data2: "global"
            data3: "local"
            data4: "src"
            global: "global position"
            local: "local position"
            src: "source position"
            user: "user position"
        cb()

  describe "validate", ->

    it "should pass schema", (cb) ->
      config.pushOrigin
        uri: "test/data/format.yml"
        filter: 'format/yaml/person'
      config.setSchema '/',
        type: 'object'
        allowedKeys: true
        keys:
          name:
            type: 'string'
          job:
            type: 'string'
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(d, 'yaml part root').to.deep.equal
          name: 'Alexander Schilling'
          job: 'Developer'
        cb()

    it "should pass schema for subpath", (cb) ->
      config.pushOrigin
        uri: "test/data/format.yml"
        filter: 'format/yaml'
      config.setSchema '/person',
        type: 'object'
        allowedKeys: true
        keys:
          name:
            type: 'string'
          job:
            type: 'string'
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(d, 'yaml part root').to.deep.equal
          string: 'test',
          longtext: 'And a long text with \' and " is possible, too',
          multiline: 'This may be a very long line in which newlines will be removed.\n',
          keepnewlines: 'Line 1\nLine 2\nLine 3\n',
          simplelist: [ 1, 2, 3 ],
          list: [ 'red', 'green', 'blue' ],
          person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

    it "should add multiple schemas", (cb) ->
      config.pushOrigin
        uri: "test/data/format.yml"
        filter: 'format/yaml'
      config.setSchema '/person',
        type: 'object'
        allowedKeys: true
        keys:
          name:
            type: 'string'
          job:
            type: 'string'
      config.setSchema '/simplelist',
        type: 'array'
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(d, 'yaml part root').to.deep.equal
          string: 'test',
          longtext: 'And a long text with \' and " is possible, too',
          multiline: 'This may be a very long line in which newlines will be removed.\n',
          keepnewlines: 'Line 1\nLine 2\nLine 3\n',
          simplelist: [ 1, 2, 3 ],
          list: [ 'red', 'green', 'blue' ],
          person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

    it "should fail schema", (cb) ->
      config.pushOrigin
        uri: "test/data/format.yml"
      config.setSchema '/',
        type: 'object'
        allowedKeys: true
        keys:
          name:
            type: 'string'
          job:
            type: 'string'
      config.init (err) ->
        expect(err, 'error').to.exist
        cb()

    it "should fail on revalidate", (cb) ->
      config.pushOrigin
        uri: "test/data/format.yml"
      config.init (err) ->
        expect(err, 'error').to.not.exist
        config.setSchema '/',
          type: 'object'
          allowedKeys: true
          keys:
            name:
              type: 'string'
            job:
              type: 'string'
        , (err) ->
          expect(err, 'error').to.exist
          cb()



