api = require './api'

stifle = (cb) ->
  (e) ->
    e.preventDefault()
    cb e
    false

module.exports = {stifle, api}
