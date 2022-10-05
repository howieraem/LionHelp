process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

if (process.env.E2E_COVERAGE) {
    environment.loaders.append('istanbul-instrumenter', {
      test: /(\.js)$/,
      use: {
        loader: 'istanbul-instrumenter-loader',
        options: { esModules: true },
      },
      enforce: 'post',
      exclude: /node_modules/
    })
  }


module.exports = environment.toWebpackConfig()
