React = require 'react'
{ connect } = require 'react-redux'
{ stifle } = require '../utils'

{ resetNewNote } = require '../ducks/common'

dispatchProps = (dispatch) ->
  onCancel: ->
    dispatch resetNewNote()

conn = connect null, dispatchProps

module.exports = conn ({atype, onSubmit, onCancel}) ->
  textarea = null

  _onSubmit = stifle ->
    onSubmit textarea.value

  _onCancel = stifle ->
    onCancel()

  <form method='post' className={'new-content ' + atype} onSubmit={_onSubmit}>
    <textarea ref={(node) => textarea = node} placeholder='Write your annotation...' />
    <button
      className={'btn btn-' + (if atype is 'question' then 'question' else 'primary')}
      type='submit'
    >
      Post
    </button>
    <button onClick={_onCancel} className='btn btn-muted'>Cancel</button>
  </form>
