R = require 'ramda'

getStore  = require('../store')
{ splat } = require '../utils'
api       = require '../api'

{ resetNewNote } = require './common'
commentsReducer  = require './comments'

reducer = (state = null, action) ->
  switch action.type
    when 'note set'
      action.note
    when 'note comment adding'
      splat state, addingComment: yes
    when 'note comment added'
      splat state,
        comments: [state.comments..., action.comment]
        addingComment: no
    else
      state and splat state, comments: R.filter Boolean, R.map ((c) -> commentsReducer c, action), (state.comments or [])

# ---

selectMarker = (marker) ->
  marker.select()
  for other in getStore().getState().notes.all
    unless other.marker is marker
      other.marker.deselect()

setNote = (note) ->
  type: 'note set'
  note: note

requestingNote = (note) ->
  setNote
    id: note.id
    loading: yes
    _marker: note._marker

reducer.requestNote = (note) ->
  (dispatch) ->
    curr = getStore().getState().note
    dispatch setNote null

    if curr and (curr.id is note.id)
      note._marker.deselect()
    else
      dispatch requestingNote note
      dispatch resetNewNote()

      api.get("notes/#{note.id}").then (data) ->
        data.note._marker = note._marker

        dispatch setNote null
        dispatch setNote data.note

        selectMarker note._marker

addingNoteComment = ->
  type: 'note comment adding'

addedNoteComment = (comment) ->
  type: 'note comment added'
  comment: comment

reducer.addNoteComment = (noteID, comment) ->
  (dispatch) ->
    dispatch addingNoteComment()
    api.post("notes/#{noteID}/comments", {comment}).then (data) ->
      dispatch addedNoteComment data.comment

module.exports = reducer
