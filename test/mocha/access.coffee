chai = require 'chai'
expect = chai.expect
#require('alinex-error').install()

describe "Init", ->

  config = require '../../src/index'

  beforeEach ->
    # reset
    #config.origin = []
    config.origin.shift() while config.origin.length
    config.schema =
      type: 'object'
    config.value = {}
    config.meta = {}
    config.listener = {}

  describe "origin", ->

    it "should add origin", (cb) ->
      config.pushOrigin
        uri: 'test/data/'
        path: 'test'
      config.init (err) ->
        expect(err, 'error').to.not.exist
        cb()

  describe "schema", ->
