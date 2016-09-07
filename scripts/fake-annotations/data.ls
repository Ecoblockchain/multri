mongoose = require 'mongoose'
{ User, Paper, Annot, Comment } = require '../../models'

mongoose.connect process.env.MONGODB_URI

for type in <[normal question]>
  let t = type
    paper = null
    ann   = null
    user  = null

    User.find-one {} .then (u) ->
      user := u
      Paper.find-by-id '57c0ce10afaa68000e89a2cb'
    .then (p) ->
      paper := p
      Annot.create do
        paper: paper
        type: t
        location:
          page: 0
          offset: {normal: 300, question: 500}[t]
    .then (a) ->
      ann := a
      paper.annots.push a
      paper.save()
    .then ->
      Comment.create do
        annot: ann
        user: user
        when: new Date
        text: 'hurrdurr'
    .then (c) ->
      ann.comments.push c
      ann.save!
      console.log 'ok done'
    .catch (err) ->
      console.error err.stack
