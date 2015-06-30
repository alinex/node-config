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
      init 'format.coffee', 'yaml', (err) ->
        expect(err, 'error').to.not.exist
        cb()

#  describe "schema", ->

