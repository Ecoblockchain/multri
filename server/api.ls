{ Router } = require 'express'
{ Note, Comment } = require './models'
utils = require './utils'
global <<< require './async'
global <<< require 'prelude-ls'

deepclean-mongo = require './deepclean-mongo'

markdown-it = require('markdown-it')!
markdown-it.use require 'markdown-it-katex'

router = Router!

router.use (i, o, next) ->
  o.error = (error) ->
    o.json {error}
  next!

router.use deepclean-mongo.middleware

router.post '/notes', utils.check-login, async (i, o) ->
  inp = i.body

  note = await create-note inp.paperID, inp.type, inp.location
  comment = await add-comment note, i.user, inp.content

  o.json note: utils.strip-note note

get-note = async (i, o, next) ->
  i.note = await (Note.find-by-id i.params.id .deep-populate 'comments.user')
  if i.note
    next!
  else
    o.error 'Not found.'

router.get '/notes/:id', get-note, (i, o) ->
  o.json {note: i.note}

create-note = async (paper-id, type, loc) ->
  paper = await Paper.find-by-id paper-id
  if paper
    note = await Note.create do
      comments: []
      paper: paper
      type: type
      location:  # todo: verify location
        page: loc.page
        offset: loc.offset

    paper.notes.push note
    await paper.save!
    note

add-comment = async (note, user, content) ->
  comment = await Comment.create do
    note: note
    user: user
    when: new Date
    content:
      text: content
      rendered: markdown-it.render content

  note.comments.push comment
  await note.save!

  id = comment._id
  comment = await (Comment.find-by-id id .deep-populate 'user')
  delete comment.note
  comment

router.post '/notes/:id/comments', get-note, async (i, o) ->
  comment = await add-comment i.note, i.user, i.body.comment
  o.json {comment}

get-comment = (i, o, next) ->
  get-note i, o, ->
    comment = await (Comment.find-by-id i.params.cid .populate 'user')
    unless comment
      return o.error 'Comment not found.'

    unless comment.note.to-string! is i.note._id.to-string!
      console.log comment.note
      console.log i.note._id
      return o.error 'Wrong note.'

    i.comment = comment
    next!

router.post '/notes/:id/comments/:cid', get-comment, async (i, o) ->
  i.comment.content
    ..text = i.body.content
    ..rendered = markdown-it.render i.body.content

  await i.comment.save!
  o.json {i.comment}

router.delete '/notes/:id/comments/:cid', get-comment, async (i, o) ->
  i.note.comments.pull i.comment._id

  await i.note.save!
  if i.note.comments.length is 0
    paper = await Paper.find-by-id i.note.paper
    paper.notes.pull i.note._id
    await paper.save!
    await i.note.remove!

  await i.comment.remove!

  o.json {success: yes}

module.exports = router
