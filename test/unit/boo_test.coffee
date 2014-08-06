boo = require '../../src/client/coffee/boo.coffee'

describe 'wiring browserify with jasmine', ->
  it 'should load boo module', ->
    expect(boo).not.toEqual undefined
