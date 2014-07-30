_ = require 'lodash'
boo = require './boo.coffee'

exports.foo = -> console.dir boo

exports.goo = -> _.last boo.moo()

console.dir boo
