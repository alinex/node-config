chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

config = require '../../src/index'

init = (file, parser, cb) ->
  config.pushOrigin
    uri: "test/data/#{file}"
    parser: parser
  config.init cb

describe "Format", ->

  beforeEach ->
    # reset
    config.origin.shift() while config.origin.length
    config.schema =
      type: 'object'
    config.value = {}
    config.meta = {}
    config.listener = {}

  describe "yaml", ->

    it "should parse", (cb) ->
      init 'format.yml', 'yaml', (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.yaml, 'yaml root').to.deep.equal
          string: 'test'
          longtext: 'And a long text with \' and " is possible, too'
          multiline: 'This may be a very long line in which newlines will be removed.\n'
          keepnewlines: 'Line 1\nLine 2\nLine 3\n'
          simplelist: [1, 2, 3]
          list: [ 'red', 'green', 'blue' ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
        cb()

    it "should parse (auto)", (cb) ->
      init 'format.yml', null, (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.yaml, 'yaml root').to.deep.equal
          string: 'test'
          longtext: 'And a long text with \' and " is possible, too'
          multiline: 'This may be a very long line in which newlines will be removed.\n'
          keepnewlines: 'Line 1\nLine 2\nLine 3\n'
          simplelist: [1, 2, 3]
          list: [ 'red', 'green', 'blue' ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
        cb()

    it "should parse (auto by content)", (cb) ->
      init 'link.yml', null, (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.link
        expect(d.yaml, 'yaml root').to.deep.equal
          string: 'test'
          longtext: 'And a long text with \' and " is possible, too'
          multiline: 'This may be a very long line in which newlines will be removed.\n'
          keepnewlines: 'Line 1\nLine 2\nLine 3\n'
          simplelist: [1, 2, 3]
          list: [ 'red', 'green', 'blue' ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
        cb()

  describe "json", ->

    it "should parse", (cb) ->
      init 'format.json', 'json', (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.json, 'json root').to.deep.equal
          string: 'test'
          list: [ 1, 2, 3 ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
        cb()

    it "should parse (auto)", (cb) ->
      init 'format.json', null, (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.json, 'json root').to.deep.equal
          string: 'test'
          list: [ 1, 2, 3 ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
        cb()

    it "should parse (auto by content)", (cb) ->
      init 'link.json', null, (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.link
        expect(d.json, 'json root').to.deep.equal
          string: 'test'
          list: [ 1, 2, 3 ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
        cb()

  describe "js", ->

    it "should parse", (cb) ->
      init 'format.js', 'js', (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.javascript, 'js root').to.deep.equal
          string: 'test'
          list: [ 1, 2, 3 ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
          session: 15*60*1000
          calc: Math.sqrt(16)
        cb()

    it "should parse (auto)", (cb) ->
      init 'format.js', null, (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.javascript, 'js root').to.deep.equal
          string: 'test'
          list: [ 1, 2, 3 ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
          session: 15*60*1000
          calc: Math.sqrt(16)
        cb()

    it "should parse (auto by content)", (cb) ->
      init 'link.js', null, (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.link
        expect(d.javascript, 'js root').to.deep.equal
          string: 'test'
          list: [ 1, 2, 3 ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
          session: 15*60*1000
          calc: Math.sqrt(16)
        cb()

  describe "cson", ->

    it "should parse", (cb) ->
      init 'format.cson', 'coffee', (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.coffee, 'cson root').to.deep.equal
          string: 'test'
          list: [ 1, 2, 3 ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
          session: 15*60*1000
          calc: Math.sqrt(16)
        cb()

    it "should parse (auto)", (cb) ->
      init 'format.cson', null, (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.coffee, 'cson root').to.deep.equal
          string: 'test'
          list: [ 1, 2, 3 ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
          session: 15*60*1000
          calc: Math.sqrt(16)
        cb()

    it "should parse (auto by content)", (cb) ->
      init 'link.cson', null, (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.link
        expect(d.coffee, 'cson root').to.deep.equal
          string: 'test'
          list: [ 1, 2, 3 ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
          session: 15*60*1000
          calc: Math.sqrt(16)
        cb()

  describe "xml", ->

    it "should parse", (cb) ->
      init 'format.xml', 'xml', (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.xml, 'xml root').to.deep.equal
          name: 'test',
          list: [ '1', '2', '3' ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
          cdata: 'i\\\'m not escaped: <xml>!'
          attributes: {value: '\n    Hello all together\n  ', type: 'detail'}
        cb()

    it "should parse (auto)", (cb) ->
      init 'format.xml', null, (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.xml, 'xml root').to.deep.equal
          name: 'test',
          list: [ '1', '2', '3' ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
          cdata: 'i\\\'m not escaped: <xml>!'
          attributes: {value: '\n    Hello all together\n  ', type: 'detail'}
        cb()

    it "should parse (auto by content)", (cb) ->
      init 'link.xml', null, (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.link
        expect(d.xml, 'xml root').to.deep.equal
          name: 'test',
          list: [ '1', '2', '3' ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
          cdata: 'i\\\'m not escaped: <xml>!'
          attributes: {value: '\n    Hello all together\n  ', type: 'detail'}
        cb()

  describe "ini", ->

    it "should parse", (cb) ->
      init 'format.ini', 'ini', (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.ini, 'ini root').to.deep.equal
          string: 'test',
          list: [ '1', '2', '3' ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
        cb()

    it "should parse (auto)", (cb) ->
      init 'format.ini', null, (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.ini, 'ini root').to.deep.equal
          string: 'test',
          list: [ '1', '2', '3' ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
        cb()

    it "should parse (auto by content)", (cb) ->
      init 'link.ini', null, (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.link
        expect(d.ini, 'ini root').to.deep.equal
          string: 'test',
          list: [ '1', '2', '3' ]
          person: {name: 'Alexander Schilling', job: 'Developer'}
        cb()

  describe "properties", ->

    it "should parse", (cb) ->
      init 'format.properties', 'properties', (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.prop, 'properties root').to.deep.equal
          string: 'test',
          list: {1: 1, 2: 2, 3: 3}
          person: {name: 'Alexander Schilling', job: 'Developer'}
        cb()

    it "should parse (auto)", (cb) ->
      init 'format.properties', null, (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.prop, 'properties root').to.deep.equal
          string: 'test',
          list: {1: 1, 2: 2, 3: 3}
          person: {name: 'Alexander Schilling', job: 'Developer'}
        cb()

    it "should parse (auto by content)", (cb) ->
      init 'link.properties', null, (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.link
        expect(d.prop, 'properties root').to.deep.equal
          string: 'test',
          list: {1: 1, 2: 2, 3: 3}
          person: {name: 'Alexander Schilling', job: 'Developer'}
        cb()
