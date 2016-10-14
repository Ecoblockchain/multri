React = require 'react'
moment = require 'moment'
{ connect } = require 'react-redux'

{ stifle } = require '../utils'
{ editComment, removeComment } = require '../ducks/comments'

dispatchProps = (dispatch) ->
  onEdit: (comment) ->
    dispatch editComment comment

  onDelete: (comment) ->
    dispatch removeComment comment

conn = connect null, dispatchProps

module.exports = conn ({user, timestamp, newComment, comment, onEdit, onDelete}) ->
  _onEdit   = stifle -> onEdit comment
  _onDelete = stifle -> onDelete comment

  <div className='comment-info cf'>
    <div className='image l'>
      <img src={user.pictureUrl} />
    </div>
    <div className='info l'>
      <div className='name'>{user.name}</div>
      {
        if newComment
          <div className='date'>
            <span className='part'>in the future</span>
          </div>
        else
          <div className='date'>
            <span className='part'>{moment(new Date(timestamp)).fromNow()}</span>
            {
              if comment?
                if window.meta.isLoggedIn
                  <span>
                    <span onClick={_onEdit} className='part link'>edit</span>
                    <span onClick={_onDelete} className='part link'>delete</span>
                  </span>
            }
          </div>
      }
    </div>
  </div>
