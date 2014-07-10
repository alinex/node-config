chai = require 'chai'
expect = chai.expect
require('alinex-error').install()

describe "Load configuration", ->

  Config = require '../../lib/index.js'

  beforeEach ->
    Config._data = {}

  describe "initial state", ->
    it "have to be missing data", ->
      expect(Config._data['test1'], 'test data missing').to.not.exist

  describe.skip "called", ->
    it "direct", ->
      Config._load 'test1'
      expect(Config._data['test1'], 'test data exist').to.exist
    it "from has method", ->
      config = new Config 'test1'
      config.has 'one'
      expect(Config._data['test1'], 'test data exist').to.exist
    it "from get method", ->
      config = new Config 'test1'
      config.get 'one'
      expect(Config._data['test1'], 'test data exist').to.exist

