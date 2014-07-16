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

    it "should succeed", (done) ->
      Config.addCheck 'test1', (name, values, cb) ->
        return cb "No title defined!" unless values.title
        cb()
      expect(Config._check).to.exist
      expect(Config._check.test1).to.exist
      expect(Config._check.test1).to.have.length 1
      config = new Config 'test1', done

    it "should fail", (done) ->
      Config.addCheck 'test1', (name, values, cb) ->
        unless values.subtitle
          return cb "No subtitle defined!"
      config = new Config 'test1', (err) ->
        return done new Error 'Error not thrown' unless err
        done()

# add check after values loaded that work
# add check after values loaded that fail
