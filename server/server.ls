express = require 'express'
global <<< require 'prelude-ls'

utils = require './utils'
config = require './config'

global <<< require './models'
global <<< require './async'

app = config.configure-app express!

app.use '/', require './auth'
app.use '/api', require './api'

app.get '/', $ (i, o) ->
  o.render 'index', {papers: _ Paper.find {}, {content: 0}}

app.get '/paper/:id', $ (i, o) ->
  paper = _ (Paper.find-by-id i.params.id .populate 'annots')
  if paper?
    o.render 'paper',
      paper: paper
      annots: map utils.strip-annot, paper.annots
  else
    o.notfound!

app.post '/mailing', $ (i, o) ->
  sub = ((_ Subscriber.find-one {email: i.body.email}) or
         (_ Subscriber.create email: i.body.email))

  msg = "Ok, #{sub.email} was added to the mailing list if it wasn't on it already."
  o.success msg, '/'

app.get '/profile', utils.check-login, (i, o) ->
  o.render 'profile'

app.post '/profile', utils.check-login, $ (i, o) ->
  i.user.picture-url = i.body.picture
  _ i.user.save!
  o.redirect '/profile'

app.use (i, o, next) ->
  o
    ..status 404
    ..render '404'

app.use (err, i, o, next) ->
  console.error err.stack
  o
    ..status 500
    ..render '500'

port = process.env.PORT or 1337
app.listen port, ->
  console.log "listening on port #{port}"