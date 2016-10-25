$ = require 'jquery'
require 'jquery-sticky'

React = require 'react'
R = require 'ramda'
{ connect } = require 'react-redux'
{ stifle } = require '../utils'

Note = require './Note'
NewNote = require './NewNote'
Loading = require './Loading'

{ initAddNote, cancelAddNote } = require '../ducks/paper'

getNewNote = (state) ->
  if state.paper.notes
    last = R.last state.paper.notes
    last if last and last.isNew

stateProps = (state) ->
  newNote: getNewNote state

dispatchProps = (dispatch) ->
  onStart: ->
    dispatch initAddNote()

  onCancel: ->
    dispatch cancelAddNote()

conn = connect(stateProps, dispatchProps)

module.exports = conn React.createClass
  _ref: (elem) ->
    $(elem).sticky topSpacing: 28

  render: ->
    if window.meta.isLoggedIn
      <div className='margin r'>
        <div ref={@_ref}>
          {
            if @props.newNote?
              <button onClick={@props.onCancel} className='btn btn-muted'>Cancel</button>
            else
              <button onClick={@props.onStart} className='btn'>Add annotation</button>
          }
        </div>
      </div>
    else
      null
