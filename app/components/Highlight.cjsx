React = require 'react'
$ = require 'jquery'

module.exports = React.createClass
  _getNoteTop: (note) ->
    { page, offset } = note.location
    $('#page-container .pf').eq(page).position().top + offset

  _topCentered: ($elem, y) ->
    margin = $elem.outerHeight() / 2
    if y?
      $elem.css 'top', "#{y - margin}px"
    else
      return $elem.position().top + margin

  _ref: (elem) ->
    $hilite = $(elem)

    $hilite.width $('#page-container .pf').outerWidth()
    if @props.note?
      @_topCentered $hilite, @_getNoteTop @props.note

    if @props.onElementLoaded?
      @props.onElementLoaded $hilite

  render: ->
    cls = 'hilite'
    if @props.selected
      cls += ' selected'

    <div ref={@_ref} className={cls} onClick={@props.onClick}>
      {@props.children}
    </div>
