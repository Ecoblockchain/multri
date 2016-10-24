{ Router } = require 'express'
_ = require 'prelude-ls'

apiutils = require './utils'
utils = require '../utils'

{ Paper, Note, Comment } = require '../models'
{ async, await } = require '../async'
deepclean-mongo = require '../deepclean-mongo'

markdown-it = require('markdown-it')()
markdown-it.use require 'markdown-it-katex'

# === middleware ===

router = Router()

router.use (i, o, next) ->
  o.error = ->
    o.json error: it
  next()

router.use deepclean-mongo.middleware

# === API routes ===

/*
router.get '/papers', async (i, o) ->
  papers = await Paper.find()
    |> _.map -> {id: id._id, title: id._title}
  o.json { papers }
*/

router.get '/papers/:pid/notes', async (i, o) ->
  paper = await Paper.find-by-id(i.params.pid).populate('notes')
  unless paper?
    return o.error 'Paper not found.'

  notes = paper.notes |> _.map ->
    id: it._id
    location: it.location

  o.json { notes }

router.post '/papers/:pid/notes',
  utils.check-login,
  apiutils.get-paper,
  async (i, o) ->
    note = await apiutils.create-note i.paper, i.body.location
    content =
      text: i.body.content
      rendered: markdown-it.render i.body.content
    await apiutils.add-comment note, i.user, content

    o.json note: utils.strip-note note

router.get '/notes/:nid',
  apiutils.get-note,
  (i, o) ->
    o.json note: i.note

router.post '/notes/:nid/comments',
  apiutils.get-note,
  async (i, o) ->
    content =
      text: i.body.comment
      rendered: markdown-it.render i.body.comment
    o.json comment: await apiutils.add-comment i.note, i.user, content

router.put '/comments/:cid',
  apiutils.get-comment,
  async (i, o) ->
    i.comment.content
      ..text = i.body.content
      ..rendered = markdown-it.render i.body.content

    await i.comment.save()
    o.json comment: i.comment

router.delete '/comments/:cid',
  apiutils.get-comment,
  async (i, o) ->
    note = await Note.find-by-id i.comment.note
    note.comments.pull i.comment._id
    await note.save()

    if note.comments.length is 0
      paper = await Paper.find-by-id note.paper
      paper.notes.pull note._id
      await paper.save()
      await note.remove()

    await i.comment.remove()
    o.json success: yes

module.exports = router
