# === include stylesheets ===

require 'normalize-css/normalize.css'
require 'spinkit/css/spinners/7-three-bounce.css'
require 'katex/dist/katex.min.css'

# === rest of app ===

React           = require 'react'
{ render }      = require 'react-dom'
{ Provider }    = require 'react-redux'
redux           = require 'redux'
thunkMiddleware = require('redux-thunk').default

App             = require './components/App'
reducer         = require './ducks'

store = redux.createStore reducer, redux.applyMiddleware thunkMiddleware
render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById 'app'
)
