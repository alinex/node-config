chai = require 'chai'
expect = chai.expect
#require('alinex-error').install()

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

    it "should allow instantiation", ->
      config = new Config 'test1'
      expect(config, 'instance').to.exist
      expect(config, 'instance').to.be.instanceof Config

  describe "loading", ->

    it "should work", (done) ->
      config = Config.instance 'test1'
      config.load ->
        expect(config.data, 'test1').to.contain.keys 'title'
        expect(config.data, 'test1').to.contain.keys 'yaml', 'json', 'javascript', 'coffee'
        done()

    it "should return data", (done) ->
      config = Config.instance 'test1'
      config.load (err, config) ->
        expect(config, 'test1').to.contain.keys 'title'
        expect(config, 'test1').to.contain.keys 'yaml', 'json', 'javascript', 'coffee'
        done()

    it "should support overloading", (done) ->
      config = new Config 'test1'
      config.load (err, config) ->
        expect(config).to.contain.keys 'title'
        expect(config.title).to.equal 'YAML Test 2'
        done()

  describe "defaults", ->

    it "should use be used", (done) ->
      config = new Config 'test1'
      config.default =
        default: "This is the default"
      config.load (err, config) ->
        expect(config).to.contain.keys 'default'
        expect(config.default).to.equal 'This is the default'
        done()

    it "should allow overriding default values", (done) ->
      config = new Config 'test1'
      config.default =
        title: "Not supported"
        default: "This is the default"
      config.load (err, config) ->
        expect(config).to.contain.keys 'default'
        expect(config.title).to.equal 'YAML Test 2'
        done()

  describe "easy get", ->

    it "should return object", (done) ->
      data =
        title: 1
        yaml: 2
      Config.get data, (err, config) ->
        expect(config, 'object').to.deep.equal data
        done()
    it "should load config by name", (done) ->
      Config.get 'test1', (err, config) ->
        expect(config, 'test1').to.contain.keys 'title'
        expect(config, 'test1').to.contain.keys 'yaml', 'json', 'javascript', 'coffee'
        done()
    it "should use given config class", (done) ->
      config = Config.instance 'test1'
      Config.get config, (err, config) ->
        expect(config, 'test1').to.contain.keys 'title'
        expect(config, 'test1').to.contain.keys 'yaml', 'json', 'javascript', 'coffee'
        done()

  describe "reloading", ->

