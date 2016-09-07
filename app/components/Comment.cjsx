React = require 'react'

CommentInfo = require './CommentInfo'
EditComment = require './EditComment'
Loading = require './Loading'

renderComment = (comment) ->
  __html: comment.content.rendered

module.exports = ({comment}) ->
  <div className='comment' key={comment.id}> 
    <CommentInfo comment={comment} user={comment.user} timestamp={comment.when} />
    {
      if comment.editing
        if comment.saving
          <Loading />
        else
          <EditComment comment={comment} />
      else if comment.deleting
        <Loading />
      else
        # comment.content.rendered always comes from the server, where it's generated (safely) by markdown-it-katex
        <div className='content' dangerouslySetInnerHTML={renderComment comment} />
    }
  </div>
