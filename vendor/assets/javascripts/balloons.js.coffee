(($, window) ->
  
  #
  # Balloon
  #
  class Balloon
    constructor: (@targetElement, @options) ->
      @createBalloon()
      @createArrow()
      @position()
      
      # Setup events.
      $(window).on 'resize', =>
        @position()
      
    createBalloon: ->
      @balloon = $("<div class='getting-started-balloon balloon'></div>")
      @balloon.html(@options['content'])
      $("body").append(@balloon)
      if @options['width']
        @balloon.css
          width: @options['width'] + "px"
      
    createArrow: ->
      @svg = d3.select("body")
        .append("svg")
        .attr("class", "getting-started-balloon container")
      @arrow = @svg.append("path")
        .attr("d", "")
        .attr("class", "getting-started-balloon arrow")
        
    position: ->
      # Position the balloon.
      targetPosition = @targetElement.offset()
      balloonOffset = @options['offset'] || {horz: -60, vert: -20}
      
      if balloonOffset.horz < 0
        left = targetPosition.left + balloonOffset.horz - @balloon.outerWidth()
      else
        left = targetPosition.left + @targetElement.outerWidth() + balloonOffset.horz
      
      top = targetPosition.top + balloonOffset.vert
        
      @balloon.css
        top: top + "px"
        left: left + "px"
        
      # Update the arrow.
      @svg.attr("width", $(document).width()).attr("height", $(document).height())
      @drawArrow()
      
    drawArrow: (from, to) ->
      origFrom = @balloonCenter()
      origTo = @targetCenter()
      
      targetInset = @options['targetInset'] || 0.6
      balloonInset = @options['balloonInset'] || 0.9
      
      # Move the points to the edge of the elements.
      from = @pointOnRectangle(origFrom, @balloon.outerWidth() * balloonInset, @balloon.outerHeight() * balloonInset, origTo)
      to = @pointOnRectangle(origTo, @targetElement.outerWidth() * targetInset, @targetElement.outerHeight() * targetInset, origFrom)
      
      segments = []
      segments.push("M", from.x, from.y)
      segments.push("L", to.x, to.y)
      #segments.push("S", (from.x + to.x)/2, (from.y + to.y)/2 + 100, to.x, to.y)
      @arrow.attr("d", segments.join(" "))
      #@arrow.attr("d", "M100 100 C 20 20, 40 30, 150 10 M150 10 L120 0 M150 10 L125 30") #lineFunction(lineData))
    
    balloonCenter: ->
      offset = @balloon.offset()
      {x: offset.left + @balloon.outerWidth()/2, y: offset.top + @balloon.outerHeight()/2}
      
    targetCenter: ->
      offset = @targetElement.offset()
      {x: offset.left + @targetElement.outerWidth()/2, y: offset.top + @targetElement.outerHeight()/2}
    
    # Give a line from the center of a rectangle to lineEnd, return the
    # point of intersection of the line and rectangle.
    pointOnRectangle: (rectCenter, rectWidth, rectHeight, lineEnd) ->
      x = lineEnd.x - rectCenter.x
      y = lineEnd.y - rectCenter.y
      tx = (rectWidth/2) / Math.abs(x)
      ty = (rectHeight/2) / Math.abs(y)
      t = Math.min(tx, ty)
      x *= t
      y *= t
      
      {x: rectCenter.x + x, y: rectCenter.y + y}
  
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
