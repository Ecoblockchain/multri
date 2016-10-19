$ = require 'jquery'
utils = require './utils'

getNoteTop = (note) ->
  { page, offset } = note.location
  $('#page-container .pf').eq(page).position().top + offset

class Hilite
  constructor: (note) ->
    @hilite = $('<div/>')
      .addClass 'yselect-hilite'
      .width $('#page-container .pf').outerWidth()
      .appendTo '#page-container'
      .click (e) => @onClick e

    @top getNoteTop note
    @toggle no

    note._hilite = @

  click: (cb) ->
    @hilite.click cb

  margin: ->
    @height() / 2

  top: (y = null) ->
    utils.centeredTop @hilite, y

  height: ->
    @hilite.outerHeight()

  remove: ->
    @hilite.remove()

  toggle: (b) ->
    @hilite.toggleClass 'selected', b

  select: -> @toggle yes
  deselect: -> @toggle no

module.exports = Hilite
