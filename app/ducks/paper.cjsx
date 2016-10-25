R = require 'ramda'
U = require './utils'

noteReducer = require './note'
{ api } = require '../utils'

SET_NOTES           = 'multri/paper/SET_NOTES'
INIT_ADD_NOTE       = 'multri/paper/INIT_ADD_NOTE'
SET_SUBMITTING_NOTE = 'multri/paper/SET_SUBMITTING_NOTE'
ADD_NOTE            = 'multri/paper/ADD_NOTE'
CANCEL_ADD_NOTE     = 'multri/paper/CANCEL_ADD_NOTE'
REMOVE_NOTE         = 'multri/paper/REMOVE_NOTE'

zapnotes = (state, func) ->
  U.zap state, 'notes', func

reducer = (state = window.meta.paper, action) ->
  switch action.type
    when SET_NOTES
      zapnotes state, R.always action.notes
    when INIT_ADD_NOTE
      zapnotes state, (notes) ->
        R.append {isNew: yes}, R.map R.dissoc('open'), notes
    when SET_SUBMITTING_NOTE
      zapnotes state, (notes) ->
        zap notes, (notes.length - 1), R.merge R.__, submitting: yes
    when ADD_NOTE
      zapnotes state, U.setlast(R.__, action.note)
    when CANCEL_ADD_NOTE
      if R.last(state.notes).isNew
        zapnotes state, U.butlast
      else
        state
    when REMOVE_NOTE
      zapnotes state, R.filter R.propEq('id', action.noteID)
    else
      U.reduceChildren state, noteReducer, action, 'notes'

reducer.setPaperNotes = (notes) ->
  type: SET_NOTES
  notes: notes

reducer.initAddNote = ->
  type: INIT_ADD_NOTE

reducer.cancelAddNote = ->
  type: CANCEL_ADD_NOTE

reducer.submitNote = (content, location) ->
  setSubmittingNote = ->
    type: SET_SUBMITTING_NOTE

  addNote = (note) ->
    type: ADD_NOTE
    note: note

  (dispatch) ->
    dispatch setSubmittingNote()
    params = { content, location, paperID: window.meta.paperID }
    api.post("papers/#{window.meta.paper.id}/notes", params).then (resp) ->
      dispatch addNote resp.note

module.exports = reducer
