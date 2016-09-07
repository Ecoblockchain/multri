mongoose = require 'mongoose'
mongoose.connect process.env.MONGODB_URI

global <<< require '../../models'
global <<< require '../../async'
global <<< require 'prelude-ls'

/*
main = $ ->
  annots = [x._id for x in _ Annot.find({})]

  papers = _ Paper.find({})
  for p in papers
    console.log p._id
    p.annots = intersection p.annots, annots
    _ p.save!
*/

main = $ ->
  updates = {}

  annots = _ Annot.find {}
  for ann in annots
    updates[ann.paper] ?= []
    updates[ann.paper].push ann._id

  for k, v of updates
    _ Paper.update {_id: k}, {annots: v}
    console.log k

main().then ->
  console.log 'ok done'
  process.exit 0
