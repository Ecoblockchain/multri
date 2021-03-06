express = require 'express'
global <<< require 'prelude-ls'

utils = require './utils'
configure-app = require './config'

global <<< require './models'
global <<< require './async'

app = configure-app express!

app.use '/', require './auth'
app.use '/api', require './api'

davheed-middleware = (i, o, next) ->
  o.locals.davheed = ('yes' in [i.query.davheed, i.cookies.davheed])
  if o.locals.davheed
    o.cookie 'davheed', 'yes', { max-age: 900000 }
  next()

app.get '/', davheed-middleware, async (i, o) ->
  o.render 'index', {papers: await Paper.find {}, {content: 0}}

app.get '/paper/:id', async (i, o) ->
  paper = await (Paper.find-by-id i.params.id .populate 'notes')
  if paper?
    o.render 'paper',
      paper: paper
      notes: map utils.strip-note, paper.notes
  else
    o.notfound!

app.get '/about', (i, o) ->
  o.render 'about'

app.post '/mailing', async (i, o) ->
  sub = ((await Subscriber.find-one {email: i.body.email}) or
         (await Subscriber.create email: i.body.email))

  msg = "Ok, #{sub.email} was added to the mailing list if it wasn't on it already."
  o.success msg, '/'

app.get '/profile', utils.check-login, (i, o) ->
  o.render 'profile'

app.post '/profile', utils.check-login, async (i, o) ->
  i.user.picture-url = i.body.picture
  await i.user.save!
  o.redirect '/profile'

app.use (i, o, next) ->
  o.notfound()

app.use (err, i, o, next) ->
  console.error err.stack
  o.status(500).render('500')

port = process.env.PORT or 1337
app.listen port, ->
  console.log "listening on port #{port}"
