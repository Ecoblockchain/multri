R = require 'ramda'
{ api } = require '../utils'

commentReducer = require './comment'

SET                = 'multri/note/SET'
SET_ADDING_COMMENT = 'multri/note/SET_ADDING_COMMENT'
ADD_COMMENT        = 'multri/note/ADD_COMMENT'
REMOVE_COMMENT     = 'multri/note/REMOVE_COMMENT'
OPEN               = 'multri/note/OPEN'
SET_COMMENTS       = 'multri/note/SET_COMMENTS'
CLOSE              = 'multri/note/CLOSE'

compact = R.filter Boolean

reduceComments = (state, action) ->
  _reduce = (comments, action) ->
    R.map ((c) -> commentReducer c, action), (comments or [])

  R.merge state, comments: compact _reduce state.comments, action

reducer = (state = null, action) ->
  if action.noteID is state.id
    switch action.type
      when SET
        action.note
      when SET_ADDING_COMMENT
        R.merge state, addingComment: yes
      when ADD_COMMENT
        ret = R.merge state,
          comments: [state.comments..., action.comment]
          addingComment: no
        console.log 'what the fuck'
        console.log ret
        ret
      when REMOVE_COMMENT
        console.log 'removing comments'
        console.log state
        ret = R.merge state, comments: R.reject ((c) -> c.id is action.commentID), state.comments
        console.log ret
        ret
      when SET_COMMENTS
        R.merge state, comments: action.comments
      when OPEN
        R.merge state, open: yes
      when CLOSE
        R.omit ['open', 'content'], state
      else
        reduceComments state, action
  else if action.type is OPEN
    R.omit ['open', 'content'], state
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

reducer.removeComment = (comm) ->
  removeComment = (comment) ->
    type: REMOVE_COMMENT
    noteID: comm.note
    commentID: comment.id

  (dispatch) ->
    console.log commentReducer.setRemovingComment
    dispatch commentReducer.setRemovingComment comm
    api.delete("comments/#{comm.id}").then ->
      dispatch removeComment comm

module.exports = reducer
