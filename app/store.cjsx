thunkMiddleware = require('redux-thunk').default
{ createStore, applyMiddleware } = require 'redux'
makeReducer = require './ducks'

store = null

module.exports = ->
  unless store?
    reducer = makeReducer()
    enhancer = applyMiddleware thunkMiddleware
    store = createStore reducer, enhancer

  store
