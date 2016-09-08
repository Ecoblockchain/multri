express       = require 'express'
path          = require 'path'
body-parser   = require 'body-parser'
cookie-parser = require 'cookie-parser'
session       = require 'express-session'
MongoStore    = require('connect-mongo')(session)
express-flash = require 'express-flash'
ellipsize     = require 'ellipsize'
passport      = require 'passport'
mongoose      = require 'mongoose'
compression   = require 'compression'

install-convenience = (i, o, next) ->
  o.locals.user = i.user
  o.locals.req = i

  o.msg = (type, e, url) ->
    i.flash type, e
    o.redirect (url or i.original-url)

  o.error = o.msg.bind o, 'error'
  o.success = o.msg.bind o, 'success'

  o.notfound = ->
    o
      ..status 404
      .render '404'

  next!

configure-app = ->
  mongoose.connect process.env.MONGODB_URI

  it
    ..use compression!
    ..use body-parser.json!
    ..use body-parser.urlencoded extended: no
    ..use cookie-parser!
    ..use session do
      secret: 'laskjdhlksajdlfka'
      store: new MongoStore mongoose-connection: mongoose.connection
      resave: no
      save-uninitialized: no
    ..use express-flash!
    ..use passport.initialize!
    ..use passport.session!
    ..use '/static', express.static path.join __dirname, '../public'
    ..set 'view engine', 'pug'
    ..locals.ellipsize = ellipsize
    ..use install-convenience

module.exports = {configure-app}
