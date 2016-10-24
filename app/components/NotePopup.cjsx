React = require 'react'

module.exports = ({children}) ->
  <div className='note' onClick={(e) -> e.stopPropagation()}>
    <div className='triangle' />
    {children}
  </div>
