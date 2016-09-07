$ = require 'jquery'
Hilite = require './hilite'

KEY_ESCAPE = 27

isInPage = ($page, y, margin) ->
  top = $page.position().top
  top + margin <= y <= top + $page.height() - margin

findNearestPos = (y, margin) ->
  ret = null
  $last = null

  $('#page-container .pf').each ->
    if isInPage $(@), y, margin
      ret = y
      return false
    if $(@).position().top + margin > y
      $last = $(@)
      return false

  unless ret?
    if $last?
      ret = $last.position().top + margin
    else
      $last = $('#page-container .pf').last()
      ret = $last.position().top + $last.height() - margin

  ret

findPageAndOffset = (y, margin) ->
  ret = null
  $('#page-container .pf').each (i) ->
    if isInPage $(@), y, margin
      ret =
        page: i
        offset: y - $(@).position().top
      return false
  ret

module.exports = (type, cb) ->
  hilite = new Hilite type
  hilite.toggle yes

  margin = hilite.margin()

  onMove = (e) ->
    y = e.pageY - $('#page-container').offset().top
    y = findNearestPos y, margin
    hilite.top y

  onSelect = (e) ->
    cb findPageAndOffset(hilite.top(), margin)
    end()

  onKey = (e) ->
    if e.keyCode is KEY_ESCAPE
      cb null
      end()

  end = ->
    hilite.remove()

    $('body')
      .off 'keydown', onKey

    $('#page-container')
      .off 'mousemove', null, onMove
      .off 'mouseenter', null, onMove
      .off 'click', null, onSelect

  $('body')
    .on 'keydown', onKey

  $('#page-container')
    .on 'mousemove', onMove
    .on 'mouseenter', onMove
    .on 'click', onSelect
