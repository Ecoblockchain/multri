strip-note = ->
  id: it._id
  type: it.type
  location: it.location

check-login = (i, o, next) ->
  if not i.user
    msg = 'You must be logged in to do that.'
    return o.error msg, '/login'
  next!

module.exports = {
  strip-note, check-login
}
