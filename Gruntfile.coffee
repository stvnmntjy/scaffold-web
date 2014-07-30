_ = require 'lodash'

###########
# folders #
###########

_src = './src'
_srcServer = "#{_src}/server"
_srcClient = "#{_src}/client"
_srcCoffee = "#{_srcClient}/coffee"
_srcJade = "#{_srcClient}/jade"
_srcLess = "#{_srcClient}/less"
_srcImg = "#{_srcClient}/img"

_test = './test'
_testUnit = "#{_test}/unit"
_testInteg = "#{_test}/integration"
_testSystem = "#{_test}/system"

_public = './public'
_publicDoc = "#{_public}/docs"
_publicHtml = "#{_public}/html"
_publicCss = "#{_public}/css"
_publicFonts = "#{_public}/fonts"
_publicImg = "#{_public}/img"
_publicJs = "#{_public}/js"

_npm = './node_modules'

##########
# source #
##########

_filesLess = _.map [
  # order client less here
  'foo.less'
], (file) -> "#{_srcLess}/#{file}"

_filesImg = _.map [
  # order client img here
], (file) -> "#{_srcImg}/#{file}"

#############
# libraries #
#############

# npm dependency module ids
_npmMods = [
  'lodash'
]

# dev
_npmCssDev = _.map [
  # order npm dev css here
], (file) -> "#{_npm}/#{file}"

# prod
_npmCssProd = _.map [
  # order npm prod css here
], (file) -> "#{_npm}/#{file}"

# common
_npmImg = _.map [
  # order npm img here
], (file) -> "#{_npm}/#{file}"
_npmFont = _.map [
  # order npm font here
], (file) -> "#{_npm}/#{file}"

copyDir = (srcDir, destDir, files) ->
  src: files
  dest: destDir
  nonull: true
  expand: true
  flatten: true
  cwd: srcDir
  filter: 'isFile'

#########
# grunt #
#########

module.exports = (grunt) ->
  grunt.initConfig
    autoprefixer:
      all:
        src: "#{_publicCss}/*.css"
    browserify:
      all:
        options:
          require: _npmMods
          transform: [
            [
              'coffeeify'
              {
                sourceMap: false
              }
            ]
          ]
          plugin: [
            [
              'minifyify'
              {
                map: "/js/bundle.map"
                output: "#{_publicJs}/bundle.map"
              }
            ]
          ]
        files: [
          {
            src: ["#{_srcCoffee}/**/*.coffee"]
            dest: "#{_publicJs}/bundle.js"
            nonull: true
          }
        ]
    clean: ["#{_public}"]
    concat:
      options:
        separator: '\n'
      dev:
        files: [
          # css
          {
            src: _npmCssDev
            dest: "#{_publicCss}/libs.css"
            nonull: true
          }
        ]
      prod:
        options:
          stripBanners:
            options:
              block: true
              line: true
        files: [
          # css
          {
            src: _npmCssProd
            dest: "#{_publicCss}/libs.css"
            nonull: true
          }
        ]
    copy:
      copy:
        files: [
          # client img
          copyDir __dirname, _publicImg, _filesImg
          # npm font
          copyDir __dirname, _publicFonts, _npmFont
          # npm img
          copyDir __dirname, _publicImg, _npmImg
        ]
    docco:
      root:
        options:
          output: "#{_publicDoc}/root"
        src: ["#{__dirname}/*.coffee"]
      server:
        options:
          output: "#{_publicDoc}/server"
        src: ["#{_srcServer}/**/*.coffee"]
      source:
        options:
          output: "#{_publicDoc}/src"
        src: ["#{_srcCoffee}/**/*.coffee"]
      test:
        options:
          output: "#{_publicDoc}/test"
        src: ["#{_test}/**/*.coffee"]
    # each file will need its own object in the array since javascript does
    # not support interpolated keys
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
    karma:
      unit:
        configFile: "#{_test}/karma.unit.conf.coffee"
      integration:
        configFile: "#{_test}/karma.integ.conf.coffee"
      system:
        configFile: "#{_test}/karma.system.conf.coffee"
    less:
      options:
        strictImports: true
        strictMath: true
        strictUnits: true
        sourceMap: true
        outputSourceFiles: true
      dev:
        files: [
          {
            src: "#{_srcLess}/**/*.less"
            dest: "#{_publicCss}/app.css"
            nonull: true
          }
        ]
      prod:
        options:
          compress: true
        files: [
          {
            src: "#{_srcLess}/**/*.less"
            dest: "#{_publicCss}/app.css"
            nonull: true
          }
        ]
    'node-inspector':
      dev: {}
    watch:
      options:
        debug: true
        interrupt: true
        livereload: true
      coffee:
        files: "#{_srcCoffee}/**/*.coffee"
        tasks: ['browserify']
      grunt:
        files: "#{__dirname}/Gruntfile.coffee"
        tasks: ['dev']
      jade:
        files: "#{_srcJade}/**/*.jade"
        tasks: ['jade:dev']
      less:
        files: "#{_srcLess}/**/*.less"
        tasks: [
          'less:dev'
        ]

  require('load-grunt-tasks') grunt

#########
# tasks #
#########

  grunt.registerTask 'dev', [
    'clean'
    'docco'
    'concat:dev'
    'copy'
    'jade:dev'
    'browserify'
    'less:dev'
    'autoprefixer'
  ]

  grunt.registerTask 'prod', [
    'clean'
    'docco'
    'concat:prod'
    'copy'
    'jade:prod'
    'browserify'
    'less:prod'
    'autoprefixer'
  ]

  grunt.registerTask 'test', [
    'karma:unit'
  ]

  return

