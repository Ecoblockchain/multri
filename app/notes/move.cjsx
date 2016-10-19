setTop = ($x, top) ->
  $x.css 'top', "#{top}px"

module.exports = ($note, hilite) ->
  half = $note.find('.comment').first().outerHeight() / 2
  setTop $note, hilite.top() - half

  $tri = $note.find('.triangle')
  setTop $tri, half - $tri.outerHeight() / 2
