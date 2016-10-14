React = require 'react'
{ connect } = require 'react-redux'

Note = require './Note'
NewNote = require './NewNote'
Loading = require './Loading'

stateProps = (state) ->
  note: state.note

module.exports = connect(stateProps) ({note}) ->
  if note?
    <Note note={note} />
  else
    <NewNote />
