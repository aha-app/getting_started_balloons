(($, window) ->
  
  #
  # Balloon
  #
  class Balloon
    constructor: (@targetElement, @options) ->
      @createBalloon()
      @createArrow()
      @position()
      
    createBalloon: ->
      @balloon = $("<div class='getting-started-balloon balloon'></div>")
      @balloon.html(@options['content'])
      $("body").append(@balloon)
      if options['width']
        @balloon.css
          width: @options['width'] + "px"
      
    createArrow: ->
      
    position: ->
      # Position the balloon.
      targetPosition = @targetElement.offset()
      balloonOffset = @options['offset'] || {horz: -20, vert: -20}
      
      if balloonOffset.horz < 0
        left = targetPosition.left + balloonOffset.horz - @balloon.width()
      else
        left = targetPosition.left + @targetElement.width() + balloonOffset.horz
      
      @balloon.css
        top: (targetPosition.top + balloonOffset.vert) + "px"
        left: left + "px"
        
        
      # Position the arrow.
      
    ###

      <svg class="tour-arrow">
        <defs>
        <filter id="chalk" height="2" width="1.6" color-interpolation-filters="sRGB" y="-0.5" x="-0.3">
          <feTurbulence baseFrequency="0.42065" seed="115" result="result1" numOctaves="1" type="turbulence"/>
          <feOffset result="result2" dx="-5" dy="-5"/>
          <feDisplacementMap scale="10" yChannelSelector="G" in2="result1" xChannelSelector="R" in="SourceGraphic"/>
        </filter></defs>

        <path d="M10 10 C 20 20, 40 30, 150 10 M150 10 L120 0 M150 10 L125 30" class="arrow" filter="url(#chalk)"/>
      </svg>
      
    ###
      

  window.Balloon = Balloon
  

)(jQuery, window)
