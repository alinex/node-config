chai = require 'chai'
expect = chai.expect
require('alinex-error').install()

describe "Configuration", ->

  Config = require '../../src/index'

  beforeEach ->
    Config.search = [
      'test/data/src'
      'test/data/local'
    ]
    Config._instances = {}

  describe "instance", ->

    it "should be retrieved from factory", ->
      config = Config.instance 'test1'
      expect(config, 'instance').to.exist
      expect(config, 'instance').to.be.instanceof Config

