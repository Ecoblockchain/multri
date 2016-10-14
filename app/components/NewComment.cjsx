React = require 'react'
{ stifle } = require '../utils'
CommentInfo = require './CommentInfo'

module.exports = ({onNewComment}) ->
  textarea = null

  _onNewComment = stifle ->
    onNewComment textarea.value

  <div>
    <CommentInfo newComment=true user={window.meta.currentUser} />
    <form className='new-comment' onSubmit={_onNewComment}>
      <textarea ref={(node) -> textarea = node} placeholder='Add a comment...' />
      <button className='btn' type='submit'>Add comment</button>
    </form>
  </div>
