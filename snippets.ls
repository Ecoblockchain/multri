app.get '/register', (i, o) ->
  o.render 'register'

app.post '/register', (i, o) ->
  user = new User do
    username: i.body.username
    name: "#{i.body.fname} #{i.body.lname}"
    is-admin: i.body.username is 'bh@brandonhsiao.com'

  User.register user, i.body.password, (err, u) ->
    if err
      return o.error 'Please enter a valid username and password.'
    passport.authenticate('local') i, o, ->
      o.redirect(i.query.redirect or '/')
