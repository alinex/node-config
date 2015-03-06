chai = require 'chai'
expect = chai.expect

describe "Checks", ->

  Config = require '../../lib/index'

  beforeEach ->
    Config.search = [
      'test/data/src'
      'test/data/local'
    ]
    Config._instances = {}

  describe "for validation", ->

    it "should succeed", (done) ->
      @timeout 5000
      config = new Config 'test1'
      config.setCheck (name, config, cb) ->
        return cb "No title defined!" unless config.title
        cb()
      config.load (err, config) ->
        expect(err).to.not.exist
        setTimeout done, 1000

    it "should fail", (done) ->
      config = new Config 'test1'
      config.setCheck (name, config, cb) ->
        return cb "No subtitle defined!" unless config.subtitle
        cb()
      config.load (err, config) ->
        expect(err).to.exist
        done()

    it "should succeed if added after loading", (done) ->
      config = new Config 'test1'
      config.load (err, data) ->
        config.setCheck (name, config, cb) ->
          return cb "No title defined!" unless config.title
          cb()
        , (err) ->
          expect(err).to.not.exist
          done()

    it "should fail if added after loading", (done) ->
      config = new Config 'test1'
      config.load (err, data) ->
        config.setCheck (name, config, cb) ->
          return cb "No title defined!" unless config.title2
          cb()
        , (err) ->
          expect(err).to.exist
          done()

  describe "for optimization", ->

    it "should extend value", (done) ->
      config = new Config 'test1'
      config.setCheck (name, config, cb) ->
        config.title += ' (changed)'
        cb()
      config.load (err, config) ->
        expect(config).to.contain.keys 'title'
        expect(config.title).to.equal 'YAML Test 2 (changed)'
        done()

    it "should add key+value", (done) ->
      config = new Config 'test1'
      config.setCheck (name, config, cb) ->
        config.mytitle = config.title + ' (changed)'
        cb()
      config.load (err, config) ->
        expect(config).to.contain.keys 'mytitle'
        expect(config.mytitle).to.equal 'YAML Test 2 (changed)'
        done()

