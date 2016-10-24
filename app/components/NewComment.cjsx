React = require 'react'
{ stifle } = require '../utils'
Loading = require './Loading'
CommentInfo = require './CommentInfo'

module.exports = ({note, onNewComment}) ->
  textarea = null

  _onSubmit = stifle ->
    onNewComment textarea.value

  if window.meta.isLoggedIn
    <div className='comment'>
      {
        if note.addingComment
          <Loading />
        else
          <div>
            <CommentInfo newComment=true user={window.meta.currentUser} />
            <form className='new-comment' onSubmit={_onSubmit}>
              <textarea ref={(node) -> textarea = node} placeholder='Add a comment...' />
              <button className='btn' type='submit'>Add comment</button>
            </form>
          </div>
      }
    </div>
  else
    null
