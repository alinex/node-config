chai = require 'chai'
expect = chai.expect
fspath = require 'path'
#require('alinex-error').install()

config = require '../../src/index'

describe "Web", ->

  beforeEach ->
    # reset
    config.origin.shift() while config.origin.length
    config.schema =
      type: 'object'
    config.value = {}
    config.meta = {}
    config.listener = {}

  describe.only "http", ->
    @timeout 5000

    it "should get json service back", (cb) ->
      config.pushOrigin
        uri: "http://echo.jsontest.com/key/value/one/two"
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(d, 'echo service').to.deep.equal
          one: "two"
          key: "value"
        cb()
