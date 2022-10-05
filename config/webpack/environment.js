const { environment } = require('@rails/webpacker')

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

module.exports = environment
