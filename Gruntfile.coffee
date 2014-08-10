_ = require 'lodash'
webpack = require 'webpack'

###########
# folders #
###########

_src = "#{__dirname}/src"
_srcServer = "#{_src}/server"
_srcClient = "#{_src}/client"
_srcCoffee = "#{_srcClient}/coffee"
_srcJade = "#{_srcClient}/jade"
_srcLess = "#{_srcClient}/less"
_srcImg = "#{_srcClient}/img"

_test = "#{__dirname}/test"
_testUnit = "#{_test}/unit"
_testInteg = "#{_test}/integration"
_testSystem = "#{_test}/system"

_public = "#{__dirname}/public"
_publicDoc = "#{_public}/docs"
_publicHtml = "#{_public}/html"
_publicCss = "#{_public}/css"
_publicFonts = "#{_public}/fonts"
_publicImg = "#{_public}/img"
_publicJs = "#{_public}/js"
_publicTest = "#{_public}/test"

_npm = "#{__dirname}/node_modules"

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

#############
# functions #
#############

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
      test:
        files: [
          {
            src: 'lib/**'
            dest: _publicTest
            nonull: true
            expand: true
            cwd: _test
          }
          copyDir __dirname, _publicTest, ['/test/SpecRunner.html']
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
    # grunt-testem runs testem in ci mode only
    testem:
      options:
        bail_on_uncaught_error: true
        cwd: _publicTest
        fail_on_zero_tests: true
      unit:
        options:
          launch_in_ci: ['chrome']
        # testem.json used now because if src is
        # the 'test_page' grunt-karma appends #testem
        # http://git.io/iRoNFA
        src: ["#{_test}/testem.json"]
        dest: "#{_publicTest}/tests.tap"
    watch:
      options:
        debug: true
        interrupt: true
        livereload: true
      coffee:
        files: "#{_srcCoffee}/**/*.coffee"
        tasks: ['webpack:dev']
      grunt:
        files: [
          "#{__dirname}/package.json"
          "#{__dirname}/Gruntfile.coffee"
        ]
        tasks: ['dev']
      jade:
        files: "#{_srcJade}/**/*.jade"
        tasks: ['jade:dev']
      less:
        files: "#{_srcLess}/**/*.less"
        tasks: [
          'less:dev'
        ]
      unit:
        files: [
          "#{_srcCoffee}/**/*.coffee"
          "#{_testUnit}/**/*.coffee"
        ]
        tasks: [
          'copy:test'
          'webpack:unit'
        ]
    webpack:
      options:
        stats:
          colors: true
          modules: true
          reasons: true
        module:
          loaders: [
            {
              test: /\.coffee$/
              loader: 'coffee-loader'
            }
          ]
        resolveLoader:
          root: _npm
        bail: true
        debug: true
        devtool: '#source-map'
        console: true
      dev:
        context: _srcCoffee
        entry: 'foo.coffee'
        output:
          path: _publicJs
          filename: 'bundle.js'
        resolve:
          root: _srcCoffee
      prod:
        context: _srcCoffee
        entry: 'foo.coffee'
        output:
          path: _publicJs
          filename: 'bundle.js'
        resolve:
          root: _srcCoffee
        plugins: [
          new webpack.optimize.UglifyJsPlugin()
        ]
      unit:
        context: _testUnit
        entry: 'spec-list.coffee'
        output:
          path: _publicTest
          filename: 'bundle.js'
        resolve:
          root: _testUnit

  require('load-grunt-tasks') grunt

#########
# tasks #
#########

  grunt.registerTask 'dev', [
    'clean'
    'concat:dev'
    'copy:copy'
    'less:dev'
    'autoprefixer'
    'jade:dev'
    'webpack:dev'
  ]

  grunt.registerTask 'prod', [
    'clean'
    'docco'
    'concat:prod'
    'copy:copy'
    'less:prod'
    'autoprefixer'
    'jade:prod'
    'webpack:prod'
  ]

  grunt.registerTask 'unit', [
    'dev'
    'copy:test'
    'webpack:unit'
    'testem:unit'
  ]

  return

