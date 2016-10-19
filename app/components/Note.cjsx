React = require 'react'
$ = require 'jquery'
{ connect } = require 'react-redux'

NewComment = require './NewComment'
Comment = require './Comment'
Loading = require './Loading'

{ moveNote } = require '../notes'
{ addNoteComment } = require '../ducks/note'

dispatchProps = (dispatch) ->
  onNewComment: (note, text) ->
    dispatch addNoteComment note.id, text

conn = connect null, dispatchProps

module.exports = conn React.createClass
  render: ->
    classes = ['note', @props.note.type]
    if @props.note.loading
      classes.push 'loading'

    <div className={classes.join ' '} ref={(node) => moveNote $(node), @props.note._marker}>
      <div className='triangle' />
      {
        if @props.note.loading
          <Loading />
        else if @props.note.comments.length > 0
          comments = for comment in @props.note.comments
            <Comment key={comment.id} comment={comment} />

          _onNewComment = (text) =>
            @props.onNewComment @props.note, text

          commentBox = (
            if window.meta.isLoggedIn
              <div className='comment'>
                {
                  if @props.note.addingComment
                    <Loading />
                  else
                    <NewComment onNewComment={_onNewComment} />
                }
              </div>
          )
          <div>{comments}{commentBox}</div>
        else
          <div>This annotation has been deleted.</div>
      }
    </div>
