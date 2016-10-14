require 'jquery-sticky'

React = require 'react'
$ = require 'jquery'
{ connect } = require 'react-redux'

{ prepareNewNote, submitNewNote } = require '../ducks/notes'
NewNoteContent = require './NewNoteContent'

stateProps = (state) ->
  newNote: state.notes.newNote

dispatchProps = (dispatch) ->
  onSetType: (type) ->
    dispatch prepareNewNote type

  onSetContent: (nn, content) ->
    dispatch submitNewNote nn.type, content, nn.location

conn = connect stateProps, dispatchProps

module.exports = conn React.createClass
  submitContent: (content) ->
    @props.onSetContent @props.newNote, content

  onNewNote: ->
    @props.onSetType 'normal'

  componentDidMount: ->
    if @controls?
      $(@controls).sticky({topSpacing: 20})
    $(window).scroll()

  componentWillUnmount: ->
    if @controls?
      $(@controls).unstick()

  render: ->
    nn = @props.newNote
    <div className='new-note' ref={(node) => @controls = node}>
      {
        if window.meta.isLoggedIn
          if nn.type?
            if nn.submitting
              <div className='nn-message'>
                Submitting...
              </div>
            else if nn.location?
              <NewNoteContent atype={nn.type} onSubmit={@submitContent} />
            else
              <div className='nn-message'>
                Please hover over the line you want to annotate and click with
                your mouse. Press Escape to cancel.
              </div>
          else
            <div className='controls'>
              <span onClick={@onNewNote} className='btn btn-lg'>Add Annotation</span>
            </div>
      }
    </div>
