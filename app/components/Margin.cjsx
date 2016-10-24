React = require 'react'
R = require 'ramda'
{ connect } = require 'react-redux'

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

module.exports = connect(stateProps) React.createClass
  render: ->
    <div className='margin r'>
      {
        if @props.newNote?
          <button onClick={@_onCancel} className='btn btn-primary'>Cancel</button>
        else
          <button onClick={@_onStart} className='btn btn-primary'>Add annotation</button>
      }
    </div>
