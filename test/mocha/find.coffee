chai = require 'chai'
expect = chai.expect

Config = require '../../lib/index'
Config.search = [
  'test/data/src'
  'test/data/local'
]

describe "Find config", ->

  it "should find all config types", (done) ->
    Config.find '', (err, list) ->
      expect(err).to.not.exist
      expect(list).to.exist
      expect(list).to.deep.equal ['test1']
      done()

