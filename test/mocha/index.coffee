chai = require 'chai'
expect = chai.expect

describe "Configuration", ->

  Config = require '../../lib/index'

  beforeEach ->
    Config._data = {}
    Config.search = [
      'test/data/src'
      'test/data/local'
    ]
    Config.default = {}
    Config._check = {}
    Config.events.removeAllListeners()

  describe "structure", ->

    it "should have static storage in class", ->
      expect(Config).to.have.property '_data'
      expect(Config._data).to.be.an 'object'

    it "should allow instantiation", (done) ->
      config = new Config 'test1', ->
        expect(config, 'instance').to.exist
        expect(config, 'instance').to.be.instanceof Config
        done()

  describe "loading", ->

    it "should load files into class", (done) ->
      config = new Config 'test1', ->
        expect(Config._data).to.have.keys 'test1'
        expect(Config._data.test1, 'test1').to.contain.keys 'title'
        expect(Config._data.test1, 'test1').to.contain.keys 'yaml', 'json', 'javascript', 'coffee'
        done()

    it "should have the properties in instance", (done) ->
      config = new Config 'test1', ->
        expect(config).to.contain.keys 'title'
        done()

    it "should support overloading", (done) ->
      config = new Config 'test1', ->
        expect(config).to.contain.keys 'title'
        expect(config.title).to.equal 'YAML Test 2'
        done()

    it "should use default values", (done) ->
      Config.default =
        test1:
          default: "This is the default"
      config = new Config 'test1', ->
        expect(config).to.contain.keys 'default'
        expect(config.default).to.equal 'This is the default'
        done()

    it "should allow overriding default values", (done) ->
      Config.default =
        test1:
          title: "Not supported"
          default: "This is the default"
      config = new Config 'test1', ->
        expect(config).to.contain.keys 'default'
        expect(config.title).to.equal 'YAML Test 2'
        done()

    it "should fire ready event", (done) ->
      config = new Config 'test1'
      config.on 'ready', ->
        expect(Config._data).to.have.keys 'test1'
        expect(Config._data.test1, 'test1').to.contain.keys 'title'
        expect(Config._data.test1, 'test1').to.contain.keys 'yaml', 'json', 'javascript', 'coffee'
        done()

    it "should get instance in callback", (done) ->
      new Config 'test1', (err, config) ->
        expect(Config._data).to.have.keys 'test1'
        expect(Config._data.test1, 'test1').to.contain.keys 'title'
        expect(Config._data.test1, 'test1').to.contain.keys 'yaml', 'json', 'javascript', 'coffee'
        done()

