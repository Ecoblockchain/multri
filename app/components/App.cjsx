React = require 'react'
Paper = require './Paper'
Margin = require './Margin'

{ connect } = require 'react-redux'
Loading = require './Loading'

module.exports = ->
  <div className='pdf-viewer cf'>
    <Paper />
    <Margin />
  </div>
