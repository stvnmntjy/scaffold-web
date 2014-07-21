'use strict';

module.exports = function (config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine'],
    files: [
      'test/helpers/**/*.coffee',
      'test/spec/components/**/*.coffee'
    ],
    preprocessors: {
      'test/spec/components/**/*.coffee': ['webpack']
    },
    webpack: {
      cache: true,
      module: {
        preLoaders: [{
          test: /\.coffee$/,
          exclude: 'node_modules',
          loader: 'coffee-loader'
        }],
        loaders: [{
          test: /\.css$/,
          loader: 'style!css'
        }, {
          test: /\.gif/,
          loader: 'url-loader?limit=10000&minetype=image/gif'
        }, {
          test: /\.jpg/,
          loader: 'url-loader?limit=10000&minetype=image/jpg'
        }, {
          test: /\.png/,
          loader: 'url-loader?limit=10000&minetype=image/png'
        }, {
          test: /\.coffee$/,
          loader: 'jsx-loader'
        }]
      }
    },
    webpackServer: {
      stats: {
        colors: true
      }
    },
    exclude: [],
    port: 8080,
    logLevel: config.LOG_INFO,
    colors: true,
    autoWatch: false,
    // Start these browsers, currently available:
    // - Chrome
    // - ChromeCanary
    // - Firefox
    // - Opera
    // - Safari (only Mac)
    // - PhantomJS
    // - IE (only Windows)
    browsers: ['PhantomJS'],
    reporters: ['progress'],
    captureTimeout: 60000,
    singleRun: true
  });
};
