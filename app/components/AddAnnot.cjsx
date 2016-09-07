React = require 'react'
$ = require 'jquery'
_unused = require 'jquery-sticky'

{ connect } = require 'react-redux'
{ prepareAddAnnot, submitAnnot } = require '../actions'

AddAnnotContent = require './AddAnnotContent'

stateProps = (state) ->
  addAnnot: state.addAnnot

dispatchProps = (dispatch) ->
  onSetType: (type) ->
    dispatch prepareAddAnnot type

  onSetContent: (aa, content) ->
    dispatch submitAnnot aa.type, content, aa.location

conn = connect stateProps, dispatchProps

module.exports = conn React.createClass
  submitContent: (content) ->
    @props.onSetContent @props.addAnnot, content

  onAddNormal: ->
    @props.onSetType 'normal'

  onAddQuestion: ->
    @props.onSetType 'question'

  componentDidMount: ->
    if @controls?
      $(@controls).sticky({topSpacing: 20})
    $(window).scroll()

  componentWillUnmount: ->
    if @controls?
      $(@controls).unstick()

  render: ->
    aa = @props.addAnnot
    <div className='add-annot' ref={(node) => @controls = node}>
      {
        if window.meta.isLoggedIn
          if aa.type?
            if aa.submitting
              <div className='aa-message'>
                Submitting...
              </div>
            else if aa.location?
              <AddAnnotContent atype={aa.type} onSubmit={@submitContent} />
            else
              <div className='aa-message'>
                Please hover over the line you want to annotate and click with
                your mouse. Press Escape to cancel.
              </div>
          else
            <div className='controls'>
              <span onClick={@onAddNormal} className='btn btn-lg'>Add Annotation</span>
              { ### <span onClick={@onAddQuestion} className='btn btn-question'>Add Question</span> ### }
            </div>
      }
    </div>
