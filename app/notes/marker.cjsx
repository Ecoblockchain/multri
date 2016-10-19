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

    note._marker = @

  toggleSelect: (@selected) ->
    @hilite.toggle @selected

  select:   -> @toggleSelect yes
  deselect: -> @toggleSelect no

  remove: ->
    @hilite.remove()
