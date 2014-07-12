chai = require 'chai'
expect = chai.expect

describe "Configuration", ->

  Config = require '../../lib/index.js'

  beforeEach ->
    Config._data = {}
    Config.search = [
      'test/data/src'
      'test/data/local'
    ]
    Config.default = {}

  describe "structure", ->

    it "should have static storage in class", ->
      expect(Config).to.have.property '_data'
      expect(Config._data).to.be.an 'object'

    it "should allow instantiation", ->
      config = new Config 'test1'
      expect(config, 'instance').to.exist
      expect(config, 'instance').to.be.instanceof Config

#    it "has access methods", ->
#      config = new Config 'test1'
#      expect(config).to.exist
#      expect(config.has, 'method has').to.be.a 'function'
#      expect(config.get, 'method get').to.be.a 'function'

  describe "loading", ->

    it "should load files into class", (cb) ->
      config = new Config 'test1', ->
        expect(Config._data).to.have.keys 'test1'
        expect(Config._data.test1, 'test1').to.contain.keys 'title'
        expect(Config._data.test1, 'test1').to.contain.keys 'yaml', 'json', 'javascript', 'coffee'
        cb()

    it "should have the properties in instance", (cb) ->
      config = new Config 'test1', ->
        expect(config).to.contain.keys 'title'
        cb()

    it "should support overloading", (cb) ->
      config = new Config 'test1', ->
        expect(config).to.contain.keys 'title'
        expect(config.title).to.equal 'YAML Test 2'
        cb()

    it "should use default values", (cb) ->
      Config.default =
        test1:
          default: "This is the default"
      config = new Config 'test1', ->
        expect(config).to.contain.keys 'default'
        expect(config.default).to.equal 'This is the default'
        cb()

    it "should allow overriding default values", (cb) ->
      Config.default =
        test1:
          title: "Not supported"
          default: "This is the default"          
      config = new Config 'test1', ->
        expect(config).to.contain.keys 'default'
        expect(config.title).to.equal 'YAML Test 2'
        cb()
