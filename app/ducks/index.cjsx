{ combineReducers } = require 'redux'

makeReducer = ->
  combineReducers
    note:     require './note'
    notes:    require './notes'
    comments: require './comments'

module.exports = makeReducer
