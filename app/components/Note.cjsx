React = require 'react'
{ connect } = require 'react-redux'

Highlight = require './Highlight'
NotePopup = require './NotePopup'
NewComment = require './NewComment'
Loading = require './Loading'
Comment = require './Comment'

{ requestNote, closeNote, addNoteComment } = require '../ducks/note'

dispatchProps = (dispatch) ->
  onToggleNote: (note) ->
    dispatch (if note.open then closeNote else requestNote) note

  onNewComment: (note, text) ->
    dispatch addNoteComment note, text

conn = connect null, dispatchProps

module.exports = conn ({onToggleNote, onNewComment, note}) ->
  _onNewComment = (text) ->
    onNewComment note, text

  _showNote = ->
    <NotePopup>
      {
        if note.comments
          <div>
            {
              for c in note.comments
                <Comment key={c.id} comment={c} />
            }
            <NewComment note={note} onNewComment={_onNewComment} />
          </div>
        else
          <Loading />
      }
    </NotePopup>

  <Highlight note={note} selected={note.open} onClick={=> onToggleNote note}>
    {if note.open then _showNote() else null}
  </Highlight>
