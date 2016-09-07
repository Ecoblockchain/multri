var webpack = require('webpack')

module.exports = {
  cache: true,
  entry: './app/index',
  output: {
    filename: 'public/bundle.js'
  },
  resolve: {
    extensions: ['', '.jsx', '.cjsx', '.coffee', '.js'],
    modulesDirectories: ['js', 'node_modules']
  },
  module: {
    loaders: [
      {test: /\.jsx$/, loader: 'jsx-loader?insertPragma=React.DOM'},
      {test: /\.cjsx$/, loaders: ['coffee', 'cjsx']},
      {test: /\.coffee$/, loader: 'coffee'}
    ]
  },
  plugins: [
    /*
    new webpack.optimize.UglifyJsPlugin(),
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.optimize.DedupePlugin(),
    new webpack.DefinePlugin({'process.env': {'NODE_ENV': '"production"'}}),
    */
  ]
}
