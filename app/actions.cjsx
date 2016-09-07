annotlib = require './annots'
api = require './api'

store = require('./store')()

# ==============

setViewingAnnot = (annot) ->
  type: 'set viewing annot'
  annot: annot

requestingAnnot = (annot) ->
  setViewingAnnot {id: annot.id, loading: yes, _marker: annot._marker}

selectSingleMarker = (marker) ->
  marker.select()
  for other in store.getState().annotMarkers
    unless other is marker
      other.deselect()

annotClicked = (annot) ->
  (dispatch) ->
    curr = store.getState().viewingAnnot
    dispatch setViewingAnnot null

    if curr and (curr.id is annot.id)
      annot._marker.deselect()
    else
      dispatch requestingAnnot annot
      dispatch resetAddAnnot()

      api.get("annots/#{annot.id}").then (data) ->
        data.annot._marker = annot._marker

        dispatch setViewingAnnot null
        dispatch setViewingAnnot data.annot

        selectSingleMarker annot._marker

# ==============

resetAddAnnot = ->
  type: 'reset add annot'

setAddAnnotType = (type) ->
  type: 'set add annot type'
  annotType: type

setAddAnnotLocation = (loc) ->
  type: 'set add annot location'
  location: loc

prepareAddAnnot = (type) ->
  (dispatch) ->
    dispatch setAddAnnotType type
    annotlib.selectPos type, (location) ->
      if location?
        dispatch setAddAnnotLocation location
      else
        dispatch resetAddAnnot()

submittingAnnot = ->
  type: 'set add annot submitting'

addMarkerToPool = (marker) ->
  type: 'add marker to pool'
  marker: marker

addMarker = (annot) ->
  (dispatch) ->
    marker = new annotlib.Marker annot
    marker.onClick = ->
      dispatch annotClicked annot

    dispatch addMarkerToPool marker

submitAnnot = (type, content, location) ->
  (dispatch) ->
    dispatch submittingAnnot()

    data = {
      type, content, location, paperID: window.meta.paperID
    }

    api.post('annots', data).then (data) ->
      window.meta.annots.push data.annot
      dispatch addMarker data.annot
      dispatch annotClicked data.annot
      dispatch resetAddAnnot()

addingComment = ->
  type: 'adding comment'

addedComment = (comment) ->
  type: 'added comment'
  comment: comment

addComment = (annotID, comment) ->
  (dispatch) ->
    dispatch addingComment()
    api.post("annots/#{annotID}/comments", {comment}).then (data) ->
      dispatch addedComment data.comment

# ==============

editComment = (comm) ->
  type: 'edit comment'
  commentID: comm.id

_savingComment = (comm) ->
  type: 'saving comment'
  commentID: comm.id

_saveComment = (comm) ->
  type: 'save comment'
  commentID: comm.id
  comment: comm

saveComment = (comm, text) ->
  (dispatch) ->
    dispatch _savingComment comm
    api.post("annots/#{comm.annot}/comments/#{comm.id}", {content: text})
      .then (data) ->
        dispatch _saveComment data.comment

_deletingComment = (comm) ->
  type: 'deleting comment'
  commentID: comm.id

_deleteComment = (comm) ->
  type: 'delete comment'
  commentID: comm.id

deleteComment = (comm, text) ->
  (dispatch) ->
    dispatch _deletingComment comm
    api.delete("annots/#{comm.annot}/comments/#{comm.id}") .then ->
      dispatch _deleteComment comm

module.exports = {
  addMarker, prepareAddAnnot, submitAnnot, resetAddAnnot,
  addComment, editComment, saveComment, deleteComment
}
