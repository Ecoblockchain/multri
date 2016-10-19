{ combineReducers } = require 'redux'

noteReducer = require './note'
{ resetNewNote } = require './common'

{ Marker, selectNotePos } = require '../notes'
{ api, splat } = require '../utils'

reduceSetType = (state = null, action) ->
  if action.type is 'new note set type'
    action.noteType
  else
    state

reduceSetLocation = (state = null, action) ->
  if action.type is 'new note set location'
    action.location
  else
    state

reduceSubmitting = (state = no, action) ->
  if action.type is 'new note submitting'
    true
  else
    state

reduceNewNote = combineReducers
  type: reduceSetType
  location: reduceSetLocation
  submitting: reduceSubmitting

reduceNotes = (state = [], action) ->
  if action.type is 'notes add'
    [state..., action.note]
  else
    state

reducer = (state = {}, action) ->
  all: reduceNotes state.all, action
  newNote: (
    if action.type is 'new note reset'
      {}
    else
      splat state.newNote, reduceNewNote state.newNote, action
  )

# ---

reducer.resetNewNote = ->
  type: 'new note reset'

setNewNoteType = (type) ->
  type: 'new note set type'
  annType: type

setNewNoteLocation = (loc) ->
  type: 'new note set location'
  location: loc

reducer.prepareNewNote = (type) ->
  (dispatch) ->
    dispatch setAddType type
    selectNotePos type, (loc) ->
      if loc?
        dispatch setAddLocation loc
      else
        dispatch reset()

submittingNewNote = ->
  type: 'new note submitting'

addMarker = (dispatch, note) ->
  marker = new Marker(note)
  marker.onClick = ->
    dispatch noteReducer.requestNote note
  marker

addNote = (note) ->
  type: 'notes add'
  note: note

reducer.addNewNote = (note, select) ->
  (dispatch) ->
    note._marker = addMarker dispatch, note
    if select
      note.marker.onClick()
    dispatch addNote note

reducer.submitNewNote = (type, content, location) ->
  (dispatch) ->
    dispatch submittingNew()

    data = {
      type, content, location, paperID: window.meta.paperID
    }

    api.post('notes', data).then (data) ->
      dispatch reducer.addNewNote data.note, yes
      dispatch resetNewNote()

module.exports = reducer
