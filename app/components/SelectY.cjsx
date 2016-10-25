React = require 'react'
R = require 'ramda'
$ = require 'jquery'
{ centeredTop } = require '../utils'

Highlight = require './Highlight'

KEY_ESCAPE = 27

module.exports = React.createClass
  getInitialState: ->
    selected: no

  _isInPage: ($page, y, margin) ->
    top = $page.position().top
    top + margin <= y <= top + $page.height() - margin

  _findNearestPos: (y, margin) ->
    pages = R.map $, $('#page-container .pf').toArray()
    findPage = R.find R.__, pages

    found = findPage ($x) => @_isInPage $x, y, margin
    if found
      return y

    $last = findPage ($x) => $x.position().top + margin > y
    if $last?
      return $last.position().top + margin

    $last = $(pages[pages.length - 1])
    return $last.position().top + $last.height() - margin

  _findPageAndOffset: (y, margin) ->
    pages = $('#page-container .pf').toArray()
    page = R.findIndex ((x) => @_isInPage $(x), y, margin), pages

    if page?
      return {
        page: page
        offset: y - $(pages[page]).position().top
      }

  _letUserSelectYPos: ($hilite, cb) ->
    margin = $hilite.outerHeight() / 2

    onMove = (e) =>
      y = e.pageY - $('#page-container').offset().top
      y = @_findNearestPos y, margin
      centeredTop $hilite, y

    onSelect = (e) =>
      console.log 'wow it was clicked that is miraculous'
      cb @_findPageAndOffset centeredTop($hilite), margin
      end()

    onKey = (e) ->
      if e.keyCode is KEY_ESCAPE
        cb null
        end()

    end = ->
      $('body').off 'keydown', onKey
      $hilite.off 'click', onSelect
      $('#page-container')
        .off 'mousemove', null, onMove
        .off 'click', null, onSelect

    $('body').on 'keydown', onKey
    $hilite.on 'click', onSelect
    $('#page-container')
      .on 'mousemove', onMove
      .on 'click', onSelect

    onMove pageY: $('#page-container').offset().top

  onLoad: ($hilite) ->
    @_letUserSelectYPos $hilite, (pos) =>
      if pos?
        @setState selected: yes
      @props.onSelectPosition pos

  render: ->
    <Highlight onElementLoaded={@onLoad} selected={@state.selected}>
      {@props.children}
    </Highlight>
