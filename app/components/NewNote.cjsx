React = require 'react'
$ = require 'jquery'
{ connect } = require 'react-redux'

NewNoteContent = require './NewNoteContent'
SelectY = require './SelectY'
NotePopup = require './NotePopup'
Loading = require './Loading'

{ submitNote, cancelAddNote } = require '../ducks/paper'

dispatchProps = (dispatch) ->
  onSubmit: (content, position) ->
    dispatch submitNote content, position

  onCancel: ->
    dispatch cancelAddNote()

conn = connect null, dispatchProps

module.exports = conn React.createClass
  getInitialState: ->
    position: null
    submitting: no

  onSubmitContent: (content) ->
    @setState submitting: yes
    @props.onSubmit content, @state.position

  onSelectPosition: (position) ->
    if position
      @setState {position}
    else
      @props.onCancel()

  _showForm: ->
    <NotePopup>
      <div className='new-note'>
        {
          if @state.submitting
            <Loading />
          else
            <NewNoteContent onSubmit={@onSubmitContent} />
        }
      </div>
    </NotePopup>

  render: ->
    <SelectY onSelectPosition={@onSelectPosition}>
      {@_showForm() if @state.position}
    </SelectY>
