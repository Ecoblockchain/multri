{ combineReducers } = require 'redux'
{ splat } = require './utils'

eachComment = (state = null, action) ->
  if action.commentID is state.id
    switch action.type
      when 'edit comment'
        splat state, editing: yes
      when 'saving comment'
        splat state, saving: yes
      when 'save comment'
        splat action.comment, editing: no, saving: no
      when 'deleting comment'
        splat state, deleting: yes
      when 'delete comment'
        return null
      else
        state
  else
    state

viewingAnnot = (state = null, action) ->
  switch action.type
    when 'set viewing annot'
      action.annot
    when 'adding comment'
      splat state, addingComment: yes
    when 'added comment'
      splat state,
        comments: [state.comments..., action.comment]
        addingComment: no
    else
      state and (
        splat state,
          comments: (
            (state.comments or [])
              .map (c) ->
                eachComment c, action
              .filter Boolean
          )
      )

addAnnotType = (state = null, action) ->
  if action.type is 'set add annot type'
    action.annotType
  else
    state

addAnnotLocation = (state = null, action) ->
  if action.type is 'set add annot location'
    action.location
  else
    state

addAnnotSubmitting = (state = no, action) ->
  if action.type is 'set add annot submitting'
    true
  else
    state

_addAnnot = combineReducers
  type: addAnnotType
  location: addAnnotLocation
  submitting: addAnnotSubmitting

addAnnot = (state = {}, action) ->
  if action.type is 'reset add annot'
    {}
  else
    splat state, _addAnnot state, action

annotMarkers = (state = [], action) ->
  if action.type is 'add marker to pool'
    [action.marker, state...]
  else
    state

module.exports = combineReducers {
  viewingAnnot, addAnnot, annotMarkers
}
