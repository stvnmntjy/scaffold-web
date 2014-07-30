module.exports = (config) ->
  config.set
    # XXX added for convenience. switch to true when actively writing tests
    autoWatch: false
    basePath: __dirname
    browsers: ['Chrome']
    files: [
      './../src/client/coffee/**/*.coffee',
      './unit/**/*.coffee'
    ]
    frameworks: [
      'jasmine'
      'browserify'
    ]
    logLevel: 'LOG_DEBUG'
    plugins: [
      'karma-browserifast'
      'karma-chrome-launcher'
      'karma-coffee-preprocessor'
      'karma-coverage'
      'karma-jasmine'
      'karma-phantomjs-launcher'
    ]
    preprocessors:
      '**/*.coffee': ['browserify']
    reporters: [
      'progress'
      'coverage'
      #'growl'
    ]
    browserify:
      files: [
        './../src/client/coffee/**/*.coffee',
        './unit/**/*.coffee'
      ]
      extensions: ['.coffee']
      transform: ['coffeeify']
    coverageReporter:
      type: 'lcov'
      dir: './../public/coverage/'
