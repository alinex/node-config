chai = require 'chai'
expect = chai.expect
#require('alinex-error').install()

config = require '../../src/index'

init = (file, parser, cb) ->
  config.pushOrigin
    uri: "test/data/#{file}"
    parser: parser
  config.init cb
  (err) -> cb


describe "Format", ->

  beforeEach ->
    # reset
    #config.origin = []
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
          simplelist: '1, 2, 3'
          list: [ 'red', 'green', 'blue' ]
          person: { name: 'Alexander Schilling', job: 'Developer' }
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
          simplelist: '1, 2, 3'
          list: [ 'red', 'green', 'blue' ]
          person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

  describe "json", ->

    it "should parse", (cb) ->
      init 'format.json', 'json', (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.json, 'json root').to.deep.equal
          string: 'test'
          list: [ 1, 2, 3 ]
          person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

    it "should parse (auto)", (cb) ->
      init 'format.json', null, (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.json, 'json root').to.deep.equal
          string: 'test'
          list: [ 1, 2, 3 ]
          person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()

  describe "js", ->

    it "should parse", (cb) ->
      init 'format.js', 'js', (err) ->
        expect(err, 'error').to.not.exist
        d = config.value.format
        expect(d.javascript, 'js root').to.deep.equal
          string: 'test'
          list: [ 1, 2, 3 ]
          person: { name: 'Alexander Schilling', job: 'Developer' }
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
          person: { name: 'Alexander Schilling', job: 'Developer' }
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
          person: { name: 'Alexander Schilling', job: 'Developer' }
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
          person: { name: 'Alexander Schilling', job: 'Developer' }
          session: 15*60*1000
          calc: Math.sqrt(16)
        cb()

