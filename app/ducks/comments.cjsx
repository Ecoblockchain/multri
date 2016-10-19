{ api, splat } = require '../utils'

reducer = (state = {}, action) ->
  if action.commentID is state.id
    switch action.type
      when 'comment edit'
        splat state, editing: yes
      when 'comment saving'
        splat state, saving: yes
      when 'comment saved'
        splat action.comment, editing: no, saving: no
      when 'comment removing'
        splat state, deleting: yes
      when 'comment removed'
        return null
      else
        state
  else
    state

# ---

reducer.editComment = (comm) ->
  type: 'comment edit'
  commentID: comm.id

savingComment = (comm) ->
  type: 'comment saving'
  commentID: comm.id

savedComment = (comm) ->
  type: 'comment saved'
  commentID: comm.id
  comment: comm

reducer.saveComment = (comm, text) ->
  (dispatch) ->
    dispatch savingComment comm
    api.post("notes/#{comm.note}/comments/#{comm.id}", {content: text})
      .then (data) ->
        dispatch savedComment data.comment

removingComment = (comm) ->
  type: 'comment removing'
  commentID: comm.id

removedComment = (comm) ->
  type: 'comment removed'
  commentID: comm.id

reducer.removeComment = (comm, text) ->
  (dispatch) ->
    dispatch removingComment comm
    api.delete("notes/#{comm.note}/comments/#{comm.id}") .then ->
      dispatch removedComment comm

module.exports = reducer
