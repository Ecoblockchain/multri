$ = require 'jquery'

setTop = ($x, top) ->
  $x.css 'top', "#{top}px"

class AnnotMover
  constructor: (@annot, @marker, @padding = 20) ->
    @annot
      .css 'position', 'fixed'
      .outerWidth @annot.parent().outerWidth()

    # precompute, though i honestly doubt it makes a difference
    @papertop = $('.paper').offset().top
    @marktop  = @marker.top + @papertop
    @triangle = @annot.find('.triangle')
    @thalf    = @triangle.outerHeight() / 2
    @mhalf    = @marker.marker.height() / 2

  bracket: (y) ->
    lo = @padding
    hi = $(window).height() - @annot.height() - @padding

    Math.max(@papertop - $(document).scrollTop(), lo, Math.min(y, hi))

  move: ->
    lo = (@thalf + @padding)
    hi = ($(window).height() - @padding - @thalf)
    y  = @marktop - $(document).scrollTop()

    if y < lo
      setTop @annot, y - @mhalf
    else if y > hi
      if @annot.height() > (hi - lo)
        setTop @annot, y - (hi - lo)
      else
        setTop @annot, y - @annot.height() + @mhalf
    else
      setTop @annot, @bracket(y - @annot.height() / 2)

    setTop @triangle, @marktop - @annot.offset().top - @thalf

module.exports = AnnotMover
