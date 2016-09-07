# usually coffeescript is way nicer than vanilla js but fuck me i can't
# believe there aren't object splats. maybe qingping has scored a point here

# maybe consider switching to livescript; we're already using on server anyway.
# is livescript + jsx a thing?

splat = (obj, props) ->
  Object.assign {}, obj, props

stifle = (cb) ->
  (e) ->
    e.preventDefault()
    cb e
    false

module.exports = {splat, stifle}
