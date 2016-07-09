chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
fspath = require 'path'

config = require '../../src/index'

describe "Other files", ->

  beforeEach ->
    # reset
    config.origin.shift() while config.origin.length
    config.register 'alinex'
    config.schema =
      type: 'object'
    config.value = {}
    config.meta = {}
    config.listener = {}

  describe "template", ->

    it "should get files", (cb) ->
      config.register 'alinex', null,
        folder: 'template'
        type: 'template'
      config.origin[1][0].uri = config.origin[1][0].uri.replace '/etc/alinex',
        fspath.resolve __dirname, '../data/app/global'
      config.origin[1][1].uri = config.origin[1][1].uri.replace /.*?\.alinex/,
        fspath.resolve __dirname, '../data/app/user'
      config.typeSearch 'template', (err, map) ->
        expect(err).to.not.exist
        expect(map).to.deep.equal
          'default.hb': '/home/alex/github/node-config/test/data/app/user/template/default.hb'
          'alinex.hb': '/home/alex/github/node-config/test/data/app/user/template/alinex.hb'
        cb()
