React = require 'react'
{ render } = require 'react-dom'
{ Provider } = require 'react-redux'

App = require './components/App'
{ addMarker } = require './actions'
store = require('./store')()

render(
  <Provider store={store}><App /></Provider>,
  document.getElementById 'margin'
)

for annot in window.meta.annots
  store.dispatch addMarker annot
