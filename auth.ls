{Router} = require 'express'
passport = require 'passport'
LocalStrategy = require 'passport-local' .Strategy
{User} = require './models'

router = Router!

passport.use new LocalStrategy User.authenticate!
passport.serialize-user User.serialize-user!
passport.deserialize-user User.deserialize-user!

check-logged-out = (i, o, next) ->
  if i.user
    return o.redirect '/'
  next!

router.get '/login', check-logged-out, (i, o) ->
  o.render 'login'

router.post '/login', check-logged-out, (i, o, next) ->
  auth = passport.authenticate 'local', (err, user) ->
    if err
      return next err
    unless user
      return o.error 'Invalid login info.'
    i.login user, (err) ->
      if err
        return next err
      o.redirect(i.query.redirect or '/')
  auth i, o, next

router.get '/logout', (i, o) ->
  i.logout!
  o.redirect '/'

module.exports = router
