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
        uri: "https://raw.githubusercontent.com/alinex/node-config/master/test/data/format.yml"
      config.init (err) ->
        expect(err, 'error').to.not.exist
        d = config.value
        expect(d, 'echo service').to.deep.equal
          yaml:
            string: 'test'
            longtext: 'And a long text with \' and " is possible, too'
            multiline: 'This may be a very long line in which newlines will be removed.\n'
            keepnewlines: 'Line 1\nLine 2\nLine 3\n'
            simplelist: [1, 2, 3]
            list: [ 'red', 'green', 'blue' ]
            person: { name: 'Alexander Schilling', job: 'Developer' }
        cb()
