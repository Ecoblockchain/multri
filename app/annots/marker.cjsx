$ = require 'jquery'
Hilite = require './hilite'
utils = require './utils'

###
makeIcon = (type) ->
  icons =
    normal: 'pencil'
    question: 'help-with-circle'
  $('<span />').addClass "icon-#{icons[type]}"
### 
getAnnotTop = (annot) ->
  { page, offset } = annot.location
  $('#page-container .pf').eq(page).position().top + offset

class Marker
  constructor: (annot) ->
    @top = getAnnotTop annot

    onClick = (e) => @onClick e

    @hilite = new Hilite annot.type
    @hilite.top @top
    @hilite.toggle no
    @hilite.click onClick

    @marker = $ '<div />'
      .addClass 'marker'
      .addClass annot.type
      # .append   makeIcon annot.type
      .appendTo '.pdf-viewer .paper'
      .hover    (=> @hilite.toggle yes), (=> @hilite.toggle @selected)
      .click    onClick

    utils.centeredTop @marker, @top
    annot._marker = @

  toggleSelect: (b) ->
    @marker.toggleClass 'selected', b
    @hilite.toggle b
    @selected = b

  select:   -> @toggleSelect yes
  deselect: -> @toggleSelect no

  remove: ->
    @marker.remove()

module.exports = Marker
