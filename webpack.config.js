const webpack = require('webpack')

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
      {test: /\.cjsx$/, loaders: ['coffee', 'cjsx']},
      {test: /\.css$/, loader: 'style-loader!css-loader'},
      {test: /\.(png|woff|woff2|eot|ttf|svg)$/, loader: 'url-loader?limit=100000'}
    ]
  },
  devtool: 'inline-source-map',
  plugins: [
    /*
    new webpack.optimize.UglifyJsPlugin(),
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.optimize.DedupePlugin(),
    new webpack.DefinePlugin({'process.env': {'NODE_ENV': '"production"'}}),
    */
  ]
}
