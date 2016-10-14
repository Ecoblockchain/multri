React = require 'react'
$ = require 'jquery'
{ connect } = require 'react-redux'

NewComment = require './NewComment'
Comment = require './Comment'
Loading = require './Loading'

{ NoteMover } = require '../notes'
{ addNoteComment } = require '../ducks/note'

dispatchProps = (dispatch) ->
  onNewComment: (note, text) ->
    dispatch addNoteComment note.id, text

conn = connect null, dispatchProps

module.exports = conn React.createClass
  componentDidMount: ->
    mover = new NoteMover @noteElm, @props.note._marker
    @move = mover.move.bind(mover)

    $(document).on 'scroll', @move
    @move()

  componentWillUnmount: ->
    $(document).off 'scroll', null, @move

  render: ->
    classes = ['note', @props.note.type]
    if @props.note.loading
      classes.push 'loading'

    <div className={classes.join ' '} ref={(node) => @noteElm = $(node)}>
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
