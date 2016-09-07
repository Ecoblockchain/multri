React = require 'react'
{ stifle } = require '../utils'
CommentInfo = require './CommentInfo'

module.exports = ({onAddComment}) ->
  textarea = null

  _onAddComment = stifle ->
    onAddComment textarea.value

  <div>
    <CommentInfo newComment=true user={window.meta.currentUser} />
    <form className='add-comment' onSubmit={_onAddComment}>
      <textarea ref={(node) -> textarea = node} placeholder='Add a comment...' />
      <button className='btn' type='submit'>Add comment</button>
    </form>
  </div>
