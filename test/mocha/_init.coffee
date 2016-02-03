chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

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
    @timeout 5000

    it "should add origin", (cb) ->
      config.pushOrigin
        uri: 'test/data/*'
        path: 'test'
      config.init (err) ->
        expect(err, 'error').to.not.exist
        cb()
