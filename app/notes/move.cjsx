$ = require 'jquery'

setTop = ($x, top) ->
  $x.css 'top', "#{top}px"

module.exports = ($note, marker) ->
  $note
    .css 'position', 'absolute'
    # .outerWidth $note.parent().outerWidth()

  half = $note.find('.comment').first().outerHeight() / 2
  setTop $note, marker.top - half

  $tri = $note.find('.triangle')
  setTop $tri, half - $tri.outerHeight() / 2


###
module.exports = class NoteMover
  constructor: (@note, @marker, @padding = 20) ->
    @note
      .css 'position', 'fixed'
      .outerWidth @note.parent().outerWidth()

    # precompute, though i honestly doubt it makes a difference
    @papertop = $('.paper').offset().top
    @marktop  = @marker.top + @papertop
    @triangle = @note.find('.triangle')
    @thalf    = @triangle.outerHeight() / 2
    @mhalf    = @marker.marker.height() / 2

  bracket: (y) ->
    lo = @padding
    hi = $(window).height() - @note.height() - @padding

    Math.max(@papertop - $(document).scrollTop(), lo, Math.min(y, hi))

  move: ->
    start = performance.now()

    lo = (@thalf + @padding)
    hi = ($(window).height() - @padding - @thalf)
    y  = @marktop - $(document).scrollTop()

    if y < lo
      setTop @note, y - @mhalf
    else if y > hi
      if @note.height() > (hi - lo)
        setTop @note, y - (hi - lo)
      else
        setTop @note, y - @note.height() + @mhalf
    else
      setTop @note, @bracket(y - @note.height() / 2)

    setTop @triangle, @marktop - @note.offset().top - @thalf

    console.log(performance.now() - start)
###
