React = require 'react'
{ connect } = require 'react-redux'
{ stifle } = require '../utils'

{ saveComment } = require '../ducks/comments'

dispatchProps = (dispatch) ->
  onSave: (comment, text) ->
    dispatch saveComment comment, text

conn = connect null, dispatchProps

module.exports = conn ({comment, onSave}) ->
  textarea = null

  _onSave = stifle ->
    onSave comment, textarea.value

  <form className='edit-comment' onSubmit={_onSave}>
    <textarea
      ref={(node) -> textarea = node}
      defaultValue={comment.content.text} />

    <button className='btn' type='submit'>Save</button>
  </form>
