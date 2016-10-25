# supplemental functions to ramda 
# usage: U = require './utils'

R = require 'ramda'

butlast = R.dropLast 1
compact = R.filter Boolean

# this func probably not suitable here
reduceChildren = (state, reducer, action, key) ->
  _reduce = (children, action) ->
    R.map ((x) -> reducer x, action), (children or [])

  R.merge state,
    "#{key}": (state[key] and
               (compact _reduce state[key], action))

truthy = (x) ->
  x and not R.isEmpty(x)

zap = (state, key, func) ->
  lens = (if R.isArrayLike(state) then R.lensIndex else R.lensProp)
  R.over lens(key), func, state

setk = (state, key, value) ->
  zap state, key, R.always(value)

setlast = (state, value) ->
  setk state, state.length - 1, value

module.exports = {
  reduceChildren, butlast, compact, truthy,
  zap, setk, setlast,
}
