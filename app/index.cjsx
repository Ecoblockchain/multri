# === include stylesheets ===

require 'normalize-css/normalize.css'
require 'spinkit/css/spinners/7-three-bounce.css'
require 'katex/dist/katex.min.css'

# === rest of app ===

React = require 'react'
{ render } = require 'react-dom'
{ Provider } = require 'react-redux'

App = require './components/App'
{ addNewNote } = require './ducks/notes'

store = require('./store')()

render(
  <Provider store={store}><App /></Provider>,
  document.getElementById 'margin'
)

for note in window.meta.notes
  store.dispatch addNewNote note
