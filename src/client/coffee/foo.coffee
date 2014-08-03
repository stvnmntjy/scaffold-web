_ = require 'lodash'
boo = require './boo.coffee'

module.exports.foo = -> console.dir boo

module.exports.goo = -> _.last boo.moo()

console.dir boo
