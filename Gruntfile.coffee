_ = require 'lodash'

# folders
_src = './src'
_srcServer = "#{_src}/server"
_srcClient = "#{_src}/client"
_srcCoffee = "#{_srcClient}/coffee"
_srcJade = "#{_srcClient}/jade"
_srcLess = "#{_srcClient}/less"
_srcImg = "#{_srcClient}/img"
_public = './public'
_publicHtml = "#{_public}/html"
_publicCss = "#{_public}/css"
_publicFonts = "#{_public}/fonts"
_publicImg = "#{_public}/img"
_publicJs = "#{_public}/js"
_bower = "./bower_components"

# files
_clientCoffee = _.map [
  # order src/client/coffee files here
  'foo.coffee'
  'boo.coffee'
], (file) -> "#{_srcCoffee}/#{file}"

_clientLess = _.map [
  # order src/client/less files here
  'foo.less'
], (file) -> "#{_srcLess}/#{file}"

_clientImg = _.map [
  # order src/client/img files here
], (file) -> "#{_srcImg}/#{file}"

# bower

# dev
_bowerJsDev = _.map [
  # order bower dev js here
], (file) -> "#{_bower}/#{file}"
_bowerCssDev = _.map [
  # order bower dev css here
], (file) -> "#{_bower}/#{file}"

# prod
_bowerJsProd = _.map [
  # order bower prod js here
], (file) -> "#{_bower}/#{file}"
_bowerCssProd = _.map [
  # order bower dev css here
], (file) -> "#{_bower}/#{file}"

# common
_bowerImg = _.map [
  # order bower img here
], (file) -> "#{_bower}/#{file}"
_bowerFont = _.map [
  # order bower font here
], (file) -> "#{_bower}/#{file}"

copyDir = (srcDir, destDir, files) ->
  src: files
  dest: destDir
  nonull: true
  expand: true
  flatten: true
  cwd: srcDir
  filter: 'isFile'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    clean: ["#{_public}"]
    coffee:
      dev:
        options:
          join: true
          sourceMap: true
        files: [
          {
            src: _clientCoffee
            dest: "#{_publicJs}/client.js"
            nonull: true
          }
        ]
      prod:
        options:
          join: true
        files: [
          {
            src: _clientCoffee
            dest: "#{_publicJs}/client.js"
            nonull: true
          }
        ]
    concat:
      dev:
        options:
          separator: '\n'
        files: [
          # css
          {
            src: _bowerCssDev
            dest: "#{_publicCss}/libs.css"
            nonull: true
          }
          # js
          {
            src: _bowerJsDev
            dest: "#{_publicJs}/libs.js"
            nonull: true
          }
        ]
      prod:
        options:
          separator: '\n'
          stripBanners:
            options:
              block: true
              line: true
        files: [
          # css
          {
            src: _bowerCssProd
            dest: "#{_publicCss}/libs.css"
            nonull: true
          }
          # js
          {
            src: _bowerJsProd
            dest: "#{_publicJs}/libs.js"
            nonull: true
          }
        ]
    copy:
      copy:
        files: [
          # client img
          copyDir __dirname, _publicImg, _clientImg
          # bower font
          copyDir __dirname, _publicFonts, _bowerFont
          # bower img
          copyDir __dirname, _publicImg, _bowerImg
        ]
    # each file will need its own object in the array since javascript does
    # not support dynamic runtime object keys
    jade:
      dev:
        options:
          pretty: true
        files: [
          {
            src: "#{_srcJade}/index.jade"
            dest: "#{_publicHtml}/index.html"
            nonull: true
          }
        ]
      prod:
        options:
          pretty: false
        files: [
          {
            src: "#{_srcJade}/index.jade"
            dest: "#{_publicHtml}/index.html"
            nonull: true
          }
        ]
    less:
      dev:
        options:
          strictImports: true
          strictMath: true
          strictUnits: true
        files: [
          {
            src: _clientLess
            dest: "#{_publicCss}/client.css"
            nonull: true
          }
        ]
      prod:
        options:
          compress: true
          strictImports: true
          strictMath: true
          strictUnits: true
        files: [
          {
            src: _clientLess
            dest: "#{_publicCss}/client.css"
            nonull: true
          }
        ]
    uglify:
      prod:
        options:
          mangle: true
          compress: true
          preserveComments: false
        files: [
          {
            src: "#{_publicJs}/client.js"
            dest: "#{_publicJs}/client.js"
            nonull: true
          }
        ]
    watch:
      grunt:
        files: "#{__dirname}/Gruntfile.coffee"
        tasks: ['dev']
      coffee:
        options:
          interrupt: true
          livereload: true
        files: "#{_srcCoffee}/**"
        tasks: ['coffee:dev']
      jade:
        options:
          interrupt: true
          livereload: true
        files: "#{_srcJade}/**"
        tasks: ['jade:dev']
      less:
        options:
          interrupt: true
          livereload: true
        files: "#{_srcLess}/**"
        tasks: ['less:dev']

  require('load-grunt-tasks') grunt

  grunt.registerTask 'dev', [
    'clean'
    'concat:dev'
    'copy:copy'
    'jade:dev'
    'coffee:dev'
    'less:dev'
  ]

  grunt.registerTask 'prod', [
    'clean'
    'concat:prod'
    'copy:copy'
    'jade:prod'
    'coffee:prod'
    'less:prod'
    'uglify:prod'
  ]

  return

