centeredTop = ($elem, y = null) ->
  margin = $elem.outerHeight() / 2

  unless y?
    return $elem.position().top + margin

  $elem.css 'top', "#{y - margin}px"

module.exports = { centeredTop }
