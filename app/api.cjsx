# all requests return json, post params are passed as json in post body
# todo: there has to be a better library than jquery

$ = require 'jquery'
Promise = require 'promise'

delayed = (cb, delay) ->
  (args...) ->
    setTimeout (-> cb args...), delay

request = (endpoint, method, data) ->
  new Promise (good, bad) ->
    opts =
      url: "/api/#{endpoint}"
      method: method
      dataType: 'json'

    if method is 'post'
      opts.contentType = 'application/json'
      opts.data = JSON.stringify data
    else
      opts.data = data

    $.ajax(opts).done(good).fail(bad)

module.exports =
  get:    (x, y) -> request x, 'get',    y
  post:   (x, y) -> request x, 'post',   y
  delete: (x, y) -> request x, 'delete', y
