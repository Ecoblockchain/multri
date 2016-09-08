{ Router } = require 'express'
{ Annot, Comment } = require './models'
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

router.post '/annots', utils.check-login, $ (i, o) ->
  inp = i.body

  annot = _ create-annot inp.paperID, inp.type, inp.location
  comment = _ add-comment annot, i.user, inp.content

  o.json annot: utils.strip-annot annot

get-annot = $ (i, o, next) ->
  i.annot = _ (Annot.find-by-id i.params.id .deep-populate 'comments.user')
  if i.annot
    next!
  else
    o.error 'Not found.'

router.get '/annots/:id', get-annot, (i, o) ->
  o.json {annot: i.annot}

create-annot = $ (paper-id, type, loc) ->
  paper = _ Paper.find-by-id paper-id
  if paper
    annot = _ Annot.create do
      comments: []
      paper: paper
      type: type
      location:  # todo: verify location
        page: loc.page
        offset: loc.offset

    paper.annots.push annot
    _ paper.save!
    annot

add-comment = $ (annot, user, content) ->
  comment = _ Comment.create do
    annot: annot
    user: user
    when: new Date
    content:
      text: content
      rendered: markdown-it.render content

  annot.comments.push comment
  _ annot.save!

  id = comment._id
  comment = _ (Comment.find-by-id id .deep-populate 'user')
  delete comment.annot
  comment

router.post '/annots/:id/comments', get-annot, $ (i, o) ->
  comment = _ add-comment i.annot, i.user, i.body.comment
  o.json {comment}

get-comment = (i, o, next) ->
  get-annot i, o, ->
    comment = _ (Comment.find-by-id i.params.cid .populate 'user')
    unless comment
      return o.error 'Comment not found.'

    unless comment.annot.to-string! is i.annot._id.to-string!
      console.log comment.annot
      console.log i.annot._id
      return o.error 'Wrong annotation.'

    i.comment = comment
    next!

router.post '/annots/:id/comments/:cid', get-comment, $ (i, o) ->
  i.comment.content
    ..text = i.body.content
    ..rendered = markdown-it.render i.body.content

  _ i.comment.save!
  o.json {i.comment}

router.delete '/annots/:id/comments/:cid', get-comment, $ (i, o) ->
  i.annot.comments.pull i.comment._id

  _ i.annot.save!
  if i.annot.comments.length is 0
    paper = _ Paper.find-by-id i.annot.paper
    paper.annots.pull i.annot._id
    _ paper.save!
    _ i.annot.remove!

  _ i.comment.remove!

  o.json {success: yes}

module.exports = router
