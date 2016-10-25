api = require './api'

stifle = (cb) ->
  (e) ->
    if cb?
      e.preventDefault()
      cb.call @, e
      false

centeredTop = ($elem, y) ->
  margin = $elem.outerHeight() / 2
  if y?
    $elem.css 'top', "#{y - margin}px"
  else
    return $elem.position().top + margin

module.exports = { api, stifle, centeredTop }
