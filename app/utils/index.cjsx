api = require './api'

splat = (obj, props) ->
  Object.assign {}, obj, props

stifle = (cb) ->
  (e) ->
    e.preventDefault()
    cb e
    false

module.exports = {splat, stifle, api}
