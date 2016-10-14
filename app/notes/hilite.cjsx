$ = require 'jquery'
utils = require './utils'

class Hilite
  constructor: (cls) ->
    @hilite = $('<div />')
      .addClass 'yselect-hilite'
      .addClass cls
      .width $('#page-container .pf').outerWidth()
      .appendTo '#page-container'

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

module.exports = Hilite
