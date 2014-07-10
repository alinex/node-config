chai = require 'chai'
expect = chai.expect

describe "Config", ->

  Config = require '../../lib/index.js'

  beforeEach ->
    Config._data = {}
    Config.search = [
      'test/data/src'
      'test/data/local'
    ]

  describe "class", ->
    it "has static storage", ->
      expect(Config).to.have.property '_data'
      expect(Config._data).to.be.an 'object'

  describe "instance", ->
    it "can be created", ->
      config = new Config 'test1'
      expect(config, 'instance').to.exist
      expect(config, 'instance').to.be.instanceof Config
    it "has access methods", ->
      config = new Config 'test1'
      expect(config).to.exist
      expect(config.has, 'method has').to.be.a 'function'
      expect(config.get, 'method get').to.be.a 'function'

  describe "init", ->
    it "should get empty object without files", (cb) ->
      Config.search = ['/not/existing/path']
      config = new Config 'test1', ->
        expect(Config._data).to.have.keys ['test1']
        expect(Config._data.test1, 'test1').to.be.empty
        cb()
    it "should load a file", (cb) ->
      config = new Config 'test1', ->
        expect(Config._data).to.have.keys ['test1']
        expect(Config._data.test1, 'test1').to.contain.keys 'title'
        cb()

