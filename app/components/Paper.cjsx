React = require 'react'
{ connect } = require 'react-redux'

Loading = require './Loading'
NewNote = require './NewNote'
Note = require './Note'

{ setPaperNotes } = require '../ducks/paper'
{ requestNote } = require '../ducks/note'

{ api } = require '../utils'

stateProps = (state) ->
  paper: state.paper

dispatchProps = (dispatch) ->
  onRequestNote: (note) ->
    dispatch requestNote note

  onSetNotes: (notes) ->
    dispatch setPaperNotes notes

module.exports = connect(stateProps, dispatchProps) React.createClass
  componentDidMount: ->
    unless @props.paper.notes
      api.get("papers/#{@props.paper.id}/notes").then (data) =>
        @props.onSetNotes data.notes

  render: ->
    <div className='paper l'>
      {
        p = @props.paper
        if p?
          <div>
            <div dangerouslySetInnerHTML={__html: p.html} />
            {
              for note in (p.notes or [])
                if note.isNew
                  <NewNote key={note.id} newNote={note} />
                else
                  <Note key={note.id} note={note} />
            }
          </div>
        else
          <Loading />
      }
    </div>
