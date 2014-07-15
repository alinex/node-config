chai = require 'chai'
expect = chai.expect

describe "Checks", ->

  Config = require '../../lib/index.js'

  beforeEach ->
    Config._data = {}
    Config._check = {}
    Config.search = [
      'test/data/src'
      'test/data/local'
    ]
    Config._check = {}

  describe "for validation", ->

    it "should succeed", ->
      expect(Config).to.have.property '_data'
      expect(Config._data).to.be.an 'object'

    it "should fail", ->
      config = new Config 'test1'
      expect(config, 'instance').to.exist
      expect(config, 'instance').to.be.instanceof Config


# add checks that work
# add checks that fail
# add check after values loaded that work
# add check after values loaded that fail
