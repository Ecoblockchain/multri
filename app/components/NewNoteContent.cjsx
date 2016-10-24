React = require 'react'
{ connect } = require 'react-redux'
{ stifle } = require '../utils'

{ cancelAddNote } = require '../ducks/paper'

dispatchProps = (dispatch) ->
  onCancel: ->
    dispatch cancelAddNote()

conn = connect null, dispatchProps

module.exports = conn ({onSubmit, onCancel}) ->
  textarea = null

  _onSubmit = stifle ->
    onSubmit textarea.value

  _onCancel = stifle onCancel

  <form method='post' className='new-content' onSubmit={_onSubmit}>
    <textarea ref={(node) => textarea = node} placeholder='Write your annotation...' />
    <button className='btn btn-primary' type='submit'>Post</button>
    <button onClick={_onCancel} className='btn btn-muted'>Cancel</button>
  </form>
