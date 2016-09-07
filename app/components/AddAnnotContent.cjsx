React = require 'react'
{ connect } = require 'react-redux'
{ resetAddAnnot } = require '../actions'
{ stifle } = require '../utils'

dispatchProps = (dispatch) ->
  onCancel: ->
    dispatch resetAddAnnot()

conn = connect null, dispatchProps

module.exports = conn ({atype, onSubmit, onCancel}) ->
  textarea = null

  _onSubmit = stifle ->
    onSubmit textarea.value

  _onCancel = stifle ->
    onCancel()

  <form method='post' className={'add-content ' + atype} onSubmit={_onSubmit}>
    <textarea ref={(node) => textarea = node} placeholder='Write your annotation...' />
    <button
      className={'btn btn-' + (if atype is 'question' then 'question' else 'primary')}
      type='submit'
    >
      Post
    </button>
    <button onClick={_onCancel} className='btn btn-muted'>Cancel</button>
  </form>
