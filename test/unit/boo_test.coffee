boo = require '../../src/client/coffee/boo.coffee'
chai = require 'chai'

chai.should()

describe 'wiring browserify with jasmine', ->
  it 'should load boo module', ->
    boo.should.exist
  it 'should load chai module', ->
    chai.should.exist
