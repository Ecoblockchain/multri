R = require 'ramda'
noteReducer = require './note'
{ butlast, reduceChildren } = require './utils'

SET_NOTES           = 'multri/paper/SET_NOTES'
INIT_ADD_NOTE       = 'multri/paper/INIT_ADD_NOTE'
SET_SUBMITTING_NOTE = 'multri/paper/SET_SUBMITTING_NOTE'
ADD_NOTE            = 'multri/paper/ADD_NOTE'
CANCEL_ADD_NOTE     = 'multri/paper/CANCEL_ADD_NOTE'
REMOVE_NOTE         = 'multri/paper/REMOVE_NOTE'

reducer = (state = window.meta.paper, action) ->
  switch action.type
    when SET_NOTES
      R.merge state, notes: action.notes
    when INIT_ADD_NOTE
      R.merge state,
        notes: R.append({isNew: yes},
                        R.map R.dissoc('open'), state.notes)
    when SET_SUBMITTING_NOTE
      R.append(R.merge(R.last(state), submiting: yes),
               R.dropLast 1, state)
    when ADD_NOTE
      R.append butlast(state), action.note
    when CANCEL_ADD_NOTE
      if R.last(state).isNew
        butlast(state)
      else
        state
    when REMOVE_NOTE
      R.merge state, notes: R.filter ((n) -> n.id is action.noteID), state.notes
    else
      reduceChildren state, noteReducer, action, 'notes'

reducer.setPaperNotes = (notes) ->
  type: SET_NOTES
  notes: notes

reducer.initAddNote = ->
  type: INIT_ADD_NOTE

reducer.cancelAddNote = ->
  type: CANCEL_ADD_NOTE

reducer.submitNewNote = (content, location) ->
  setSubmittingNote = ->
    type: SET_SUBMITTING_NOTE

  addNewNote = (note) ->
    type: ADD_NOTE
    note: note

  (dispatch) ->
    dispatch setSubmittingNote()
    params = { content, location, paperID: window.meta.paperID }
    api.post('notes', params).then (resp) ->
      dispatch addNewNote resp.note

module.exports = reducer
