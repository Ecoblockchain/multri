redux           = require 'redux'
thunkMiddleware = require('redux-thunk').default
makeReducer     = require './ducks'

store = null

module.exports = ->
  unless store?
    reducer = makeReducer()
    enhancer = redux.applyMiddleware thunkMiddleware
    store = redux.createStore reducer, enhancer

  store
