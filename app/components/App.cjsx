React = require 'react'
{ connect } = require 'react-redux'

Annot = require './Annot'
AddAnnot = require './AddAnnot'
Loading = require './Loading'

stateProps = (state) ->
  annot: state.viewingAnnot

module.exports = connect(stateProps) ({annot}) ->
  if annot?
    <Annot annot={annot} />
  else
    <AddAnnot />
