React = require 'react'
$ = require 'jquery'
{ stifle, centeredTop } = require '../utils'

module.exports = React.createClass
  _getNoteTop: (note) ->
    { page, offset } = note.location
    $('#page-container .pf').eq(page).position().top + offset

  _ref: (elem) ->
    $hilite = $(elem)

    $hilite.width $('#page-container .pf').outerWidth()
    if @props.note?
      centeredTop $hilite, @_getNoteTop @props.note

    if @props.onElementLoaded?
      @props.onElementLoaded $hilite

  _onClick: (e) ->
    if @props.onClick?
      e.preventDefault()
      @props.onClick e
      return false

  render: ->
    cls = 'hilite'
    if @props.selected
      cls += ' selected'

    <div ref={@_ref} className={cls} onClick={@_onClick}>
      {@props.children}
    </div>
