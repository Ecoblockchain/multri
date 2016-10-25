R = require 'ramda'
U = require './utils'

{ api } = require '../utils'

commentReducer = require './comment'

SET_ADDING_COMMENT = 'multri/note/SET_ADDING_COMMENT'
ADD_COMMENT        = 'multri/note/ADD_COMMENT'
OPEN               = 'multri/note/OPEN'
SET_COMMENTS       = 'multri/note/SET_COMMENTS'
CLOSE              = 'multri/note/CLOSE'

reduceComments = (state, action) ->
  state = U.reduceChildren state, commentReducer, action, 'comments'
  if state.comments? and R.isEmpty state.comments
    null
  else
    state

reducer = (state = null, action) ->
  if action.noteID is state.id
    switch action.type
      when SET_ADDING_COMMENT
        R.merge state, addingComment: yes
      when ADD_COMMENT
        R.merge state,
          comments: R.append action.comment, state.comments
          addingComment: no
      when SET_COMMENTS
        R.merge state, comments: action.comments
      when OPEN
        R.merge state, open: yes
      when CLOSE
        R.dissoc 'open', state
      else
        reduceComments state, action
  else if action.type is OPEN
    R.dissoc 'open', state
  else
    reduceComments state, action

# ---

reducer.requestNote = (note) ->
  openNote = (note) ->
    type: OPEN
    noteID: note.id

  setNoteComments = (note, comments) ->
    type: SET_COMMENTS
    noteID: note.id
    comments: comments

  (dispatch) ->
    dispatch openNote note
    api.get("notes/#{note.id}").then (data) ->
      dispatch setNoteComments note, data.note.comments

reducer.closeNote = (note) ->
  type: CLOSE
  noteID: note.id

reducer.addNoteComment = (note, comment) ->
  addingNoteComment = ->
    type: SET_ADDING_COMMENT
    noteID: note.id

  addNoteComment = (comment) ->
    type: ADD_COMMENT
    noteID: note.id
    comment: comment

  (dispatch) ->
    dispatch addingNoteComment()
    api.post("notes/#{note.id}/comments", {comment}).then (data) ->
      dispatch addNoteComment data.comment

module.exports = reducer
