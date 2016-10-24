_ = require 'prelude-ls'

{ async, await } = require '../async'
{ Paper, Note, Comment } = require '../models'

get-paper = async (i, o, next) ->
  i.paper = await Paper.find-by-id i.params.pid

  if i.paper? then next() else o.error 'Paper not found.'

get-note = async (i, o, next) ->
  i.note = await Note.find-by-id(i.params.nid).deep-populate('comments.user')

  if i.note? then next() else o.error 'Note not found.'

create-note = async (paper, loc) ->
  note = await Note.create do
    comments: []
    paper: paper
    location:  # todo: verify location
      page: loc.page
      offset: loc.offset

  paper.notes.push note
  await paper.save()
  note

add-comment = async ( note, user, content) ->
  comment = await Comment.create do
    note: note
    user: user
    when: new Date
    content: content

  note.comments.push comment
  await note.save()

  comment = await (Comment.find-by-id comment._id .deep-populate 'user')
  delete comment.note
  comment

get-comment = async (i, o, next) ->
  comment = await (Comment.find-by-id i.params.cid .populate 'user')
  unless comment
    return o.error 'Comment not found.'

  i.comment = comment
  next()

module.exports = { get-paper, get-note, create-note, add-comment, get-comment }
