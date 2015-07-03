chai = require 'chai'
expect = chai.expect
#require('alinex-error').install()

describe "Access", ->

  config = require '../../src/index'

  beforeEach (cb) ->
    # reset
    #config.origin = []
    config.origin.shift() while config.origin.length
    config.schema =
      type: 'object'
    config.value = {}
    config.meta = {}
    config.listener = {}
    # initialize load
    config.pushOrigin
      uri: "test/data/format.*"
    config.init cb


  describe "init", ->

    it "should load data", ->
      expect(config.value, 'values').to.deep.equal
        format:
          coffee:
            string: 'test'
            list: [ 1, 2, 3 ]
            person:
              name: 'Alexander Schilling'
              job: 'Developer'
            session: 900000
            calc: 4
          ini:
            string: 'test'
            list: [ "1", "2", "3" ]
            person:
              name: 'Alexander Schilling'
              job: 'Developer'
          javascript:
            string: 'test'
            list: [ 1, 2, 3 ]
            person:
              name: 'Alexander Schilling'
              job: 'Developer'
            session: 900000
            calc: 4
          json:
            string: 'test'
            list: [ 1, 2, 3 ]
            person:
              name: 'Alexander Schilling'
              job: 'Developer'
          prop:
            string: 'test'
            list: { '1': 1, '2': 2, '3': 3 }
            person:
              name: 'Alexander Schilling'
              job: 'Developer'
          xml:
            name: 'test'
            list: [ '1', '2', '3' ]
            person:
              name: 'Alexander Schilling'
              job: 'Developer'
            cdata: 'i\\\'m not escaped: <xml>!'
            attributes:
              value: '\n    Hello all together\n  '
              type: 'detail'
          yaml:
            string: 'test'
            longtext: 'And a long text with \' and " is possible, too'
            multiline: 'This may be a very long line in which newlines will be removed.\n'
            keepnewlines: 'Line 1\nLine 2\nLine 3\n'
            simplelist: [ 1, 2, 3 ]
            list: [
              'red'
              'green'
              'blue'
            ]
            person:
              name: 'Alexander Schilling'
              job: 'Developer'

  describe "get", ->

    it "should load all", ->
      expect(config.get('/'), 'values').to.deep.equal
        format:
          coffee:
            string: 'test'
            list: [ 1, 2, 3 ]
            person:
              name: 'Alexander Schilling'
              job: 'Developer'
            session: 900000
            calc: 4
          ini:
            string: 'test'
            list: [ "1", "2", "3" ]
            person:
              name: 'Alexander Schilling'
              job: 'Developer'
          javascript:
            string: 'test'
            list: [ 1, 2, 3 ]
            person:
              name: 'Alexander Schilling'
              job: 'Developer'
            session: 900000
            calc: 4
          json:
            string: 'test'
            list: [ 1, 2, 3 ]
            person:
              name: 'Alexander Schilling'
              job: 'Developer'
          prop:
            string: 'test'
            list: { '1': 1, '2': 2, '3': 3 }
            person:
              name: 'Alexander Schilling'
              job: 'Developer'
          xml:
            name: 'test'
            list: [ '1', '2', '3' ]
            person:
              name: 'Alexander Schilling'
              job: 'Developer'
            cdata: 'i\\\'m not escaped: <xml>!'
            attributes:
              value: '\n    Hello all together\n  '
              type: 'detail'
          yaml:
            string: 'test'
            longtext: 'And a long text with \' and " is possible, too'
            multiline: 'This may be a very long line in which newlines will be removed.\n'
            keepnewlines: 'Line 1\nLine 2\nLine 3\n'
            simplelist: [ 1, 2, 3 ]
            list: [
              'red'
              'green'
              'blue'
            ]
            person:
              name: 'Alexander Schilling'
              job: 'Developer'

    it "should get sub part starting with slash", ->
      expect(config.get('/format/coffee'), 'values').to.deep.equal
        string: 'test'
        list: [ 1, 2, 3 ]
        person:
          name: 'Alexander Schilling'
          job: 'Developer'
        session: 900000
        calc: 4

    it "should get sub part starting without slash", ->
      expect(config.get('format/coffee'), 'values').to.deep.equal
        string: 'test'
        list: [ 1, 2, 3 ]
        person:
          name: 'Alexander Schilling'
          job: 'Developer'
        session: 900000
        calc: 4

    it "should get nothing if not there", ->
      expect(config.get('format/alex'), 'values').to.not.exist

  describe "has", ->

    it "should succeed for all", ->
      expect(config.get('/'), 'values').to.exist

    it "should succeed for all", ->
      expect(config.get('format/coffee'), 'values').to.exist

    it "should succeed for all", ->
      expect(config.get('format/alex'), 'values').to.not.exist
