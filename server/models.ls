mongoose = require 'mongoose'
deep-populate = require 'mongoose-deep-populate'
mongoose.Promise = Promise
plm = require 'passport-local-mongoose'
Schema = mongoose.Schema

deep-populate = deep-populate mongoose

ref = (t) ->
  type: Schema.Types.ObjectId
  ref: t

User = new Schema do
  name: String
  username: String
  password: String
  picture-url: String
  is-admin: Boolean

Paper = new Schema do
  title: String
  hide: Boolean
  content:
    css: String
    html: String
  notes: [ref 'Note']

Note = new Schema do
  paper: ref 'Paper'
  location:
    page: Number
    offset: Number
  comments: [ref 'Comment']

Comment = new Schema do
  note: ref 'Note'
  user: ref 'User'
  when: Date
  content:
    text: String
    rendered: String

Subscriber = new Schema do
  email: String

User.plugin plm
Note.plugin deep-populate
Comment.plugin deep-populate

module.exports =
  User: mongoose.model 'User', User
  Paper: mongoose.model 'Paper', Paper
  Note: mongoose.model 'Note', Note
  Comment: mongoose.model 'Comment', Comment
  Subscriber: mongoose.model 'Subscriber', Subscriber
