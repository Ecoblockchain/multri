thunkMiddleware = require('redux-thunk').default
{ createStore, applyMiddleware } = require 'redux'
reducer = require './reducers'

store = null

module.exports = ->
  store ?= createStore reducer, applyMiddleware thunkMiddleware
  store
