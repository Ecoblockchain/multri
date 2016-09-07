React = require 'react'
$ = require 'jquery'
{ connect } = require 'react-redux'
AddComment = require './AddComment'
Comment = require './Comment'
Loading = require './Loading'
{ addComment } = require '../actions'
annotlib = require '../annots'

dispatchProps = (dispatch) ->
  onAddComment: (annot, text) ->
    dispatch addComment annot.id, text

conn = connect null, dispatchProps

module.exports = conn React.createClass
  componentDidMount: ->
    mover = new annotlib.AnnotMover @annotElm, @props.annot._marker
    @move = mover.move.bind(mover)

    $(document).on 'scroll', @move
    @move()

  componentWillUnmount: ->
    $(document).off 'scroll', null, @move

  render: ->
    classes = ['annot', @props.annot.type]
    if @props.annot.loading
      classes.push 'loading'

    <div className={classes.join ' '} ref={(node) => @annotElm = $(node)}>
      <div className='triangle' />
      {
        if @props.annot.loading
          <Loading />
        else if @props.annot.comments.length > 0
          comments = for comment in @props.annot.comments
            <Comment key={comment.id} comment={comment} />

          _onAddComment = (text) =>
            @props.onAddComment @props.annot, text

          commentBox = (
            if window.meta.isLoggedIn
              <div className='comment'>
                {
                  if @props.annot.addingComment
                    <Loading />
                  else
                    <AddComment onAddComment={_onAddComment} />
                }
              </div>
          )
          <div>{comments}{commentBox}</div>
        else
          <div>This annotation has been deleted.</div>
      }
    </div>
