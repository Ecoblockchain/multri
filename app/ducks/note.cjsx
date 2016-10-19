R = require 'ramda'

getStore       = require('../store')
{ api, splat } = require '../utils'

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

selectHilite = (hilite) ->
  hilite.select()
  for other in getStore().getState().notes.all
    unless other._hilite is hilite
      other._hilite.deselect()

setNote = (note) ->
  type: 'note set'
  note: note

requestingNote = (note) ->
  setNote
    id: note.id
    loading: yes
    _hilite: note._hilite

reducer.requestNote = (note) ->
  (dispatch) ->
    curr = getStore().getState().note
    dispatch setNote null

    if curr and (curr.id is note.id)
      note._hilite.deselect()
    else
      dispatch requestingNote note
      dispatch resetNewNote()

      api.get("notes/#{note.id}").then (data) ->
        data.note._hilite = note._hilite

        dispatch setNote null
        dispatch setNote data.note

        selectHilite note._hilite

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
