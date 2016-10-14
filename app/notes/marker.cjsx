$ = require 'jquery'
Hilite = require './hilite'
utils = require './utils'

getNoteTop = (note) ->
  { page, offset } = note.location
  $('#page-container .pf').eq(page).position().top + offset

module.exports = class Marker
  constructor: (note) ->
    @top = getNoteTop note

    onClick = (e) => @onClick e

    @hilite = new Hilite note.type
    @hilite.top @top
    @hilite.toggle no
    @hilite.click onClick

    @marker = $ '<div />'
      .addClass 'marker'
      .addClass note.type
      .appendTo '.pdf-viewer .paper'
      .hover    (=> @hilite.toggle yes), (=> @hilite.toggle @selected)
      .click    onClick

    utils.centeredTop @marker, @top
    note._marker = @

  toggleSelect: (b) ->
    @marker.toggleClass 'selected', b
    @hilite.toggle b
    @selected = b

  select:   -> @toggleSelect yes
  deselect: -> @toggleSelect no

  remove: ->
    @marker.remove()
