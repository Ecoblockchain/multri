# Takes an object possibly containing mongoose documents, replaces _id
# with id, and removes __v.  Could probably be own package in future.

global <<< require 'prelude-ls'

is-object = is-type 'Object'
is-array  = is-type 'Array'

# todo: handle circular refs
deepclean = (obj) ->
  unless (is-object obj) or (is-array obj)
    return obj

  if obj.{}constructor.name is 'model'
    return deepclean obj.to-object!

  if is-object obj
    pairs-to-obj filter id, (
      obj-to-pairs obj |> map ([k, v]) ->
        unless k is '__v'
          [{_id: 'id'}[k] or k, deepclean v]
    )
  else
    map deepclean, obj

middleware = (i, o, next) ->
  o.json = o.json.bind(o) . deepclean
  next!

module.exports = { deepclean, middleware }
