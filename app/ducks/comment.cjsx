R = require 'ramda'
{ api } = require '../utils'

SET_EDITING = 'multri/comment/SET_EDITING'
SET_SAVING = 'multri/comment/SET_SAVING'
SAVE = 'multri/comment/SET_SAVED'
SET_REMOVING = 'multri/comment/SET_REMOVING'
REMOVE = 'multri/comment/REMOVE'

reducer = (state = {}, action) ->
  if action.commentID is state.id
    switch action.type
      when SET_EDITING  then R.merge state, editing: yes
      when SET_SAVING   then R.merge state, saving: yes
      when SAVE         then action.comment
      when SET_REMOVING then R.merge state, deleting: yes
      when REMOVE       then null
      else state
  else
    state

# ---

reducer.editComment = (comm) ->
  type: SET_EDITING
  commentID: comm.id

savingComment = (comm) ->
  type: SET_SAVING
  commentID: comm.id

saveComment = (comm) ->
  type: SAVE
  commentID: comm.id
  comment: comm

reducer.saveComment = (comm, text) ->
  (dispatch) ->
    dispatch savingComment comm
    api.put("comments/#{comm.id}", {content: text})
      .then (data) ->
        dispatch saveComment data.comment

reducer.removeComment = (comm) ->
  _setRemovingComment = (comm) ->
    type: SET_REMOVING
    commentID: comm.id

  _removeComment = (comm) ->
    type: REMOVE
    commentID: comm.id

  (dispatch) ->
    dispatch _setRemovingComment comm
    api.delete("comments/#{comm.id}").then ->
      dispatch _removeComment comm


module.exports = reducer
