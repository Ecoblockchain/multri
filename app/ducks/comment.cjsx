R = require 'ramda'
{ api } = require '../utils'

SET_EDITING = 'multri/comment/SET_EDITING'
SET_SAVING = 'multri/comment/SET_SAVING'
SAVE = 'multri/comment/SET_SAVED'
SET_REMOVING = 'multri/comment/SET_REMOVING'

reducer = (state = {}, action) ->
  if action.commentID is state.id
    R.merge state, (
      switch action.type
        when SET_EDITING  then editing: yes
        when SET_SAVING   then saving: yes
        when SAVE         then R.merge action.comment, editing: no, saving: no
        when SET_REMOVING then deleting: yes
        else {}
      )
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

reducer.setRemovingComment = (comm) ->
  type: SET_REMOVING
  commentID: comm.id

module.exports = reducer
