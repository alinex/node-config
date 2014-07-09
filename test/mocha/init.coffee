chai = require 'chai'
expect = chai.expect

describe "Config", ->

  Config = require '../../lib/index.js'

  describe "class", ->
    it "has static storage", ->
      expect(Config, '_data').to.have.property '_data'
      expect(Config._data, 'is object').to.be.an 'object'

  describe "instance", ->
    it "can be created", ->
      config = new Config 'test1'
      expect(config, 'object exists').to.exist
      expect(config, 'is instance').to.be.instanceof Config
    it "has access methods", ->
      config = new Config 'test1'
      expect(config).to.exist
      expect(config.has).to.be.a 'function'
      expect(config.get).to.be.a 'function'

