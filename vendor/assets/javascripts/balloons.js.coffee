(($, window) ->
  
  #
  # Balloon
  #
  class Balloon
    @createdFilter = false
    
    constructor: (@targetElement, @options) ->
      @createFilter() unless Balloon.createdFilter
      @createBalloon()
      @createArrow()
      @position()

      # Setup events.
      $(window).on 'resize', =>
        @position()
      @balloon.on 'click', '.close-box', =>
        @close()
      
    createBalloon: ->
      @balloon = $("<div class='getting-started-balloon balloon'></div>")
      @balloon.html("<div class='close-box'>x</div>" + @options['content'])
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
        .attr("filter", "url(#getting-started-balloon-chalk)")
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
      middle = @perpendicularOffset(from, to, 0.5, 20, true)
      
      segments = []
      segments.push("M", from.x, from.y)
      #segments.push("L", to.x, to.y)
      segments.push("C", middle.x, middle.y, middle.x, middle.y, to.x, to.y)
      arrowStart = @perpendicularOffset(middle, to, 0.5, 15, false, false)
      arrowEnd = @perpendicularOffset(middle, to, 0.5, 15, false, true)
      segments.push("M", arrowStart.x, arrowStart.y, to.x, to.y, arrowEnd.x, arrowEnd.y)
      @arrow.attr("d", segments.join(" "))
    
    close: ->
      @balloon.remove()
      @svg.remove()
      
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
  
    # Find a point that is offset from point on the line.
    perpendicularOffset: (from, to, percentAlong, offset, alwaysDown = false, opposite = false) ->
      mx = from.x + (to.x - from.x) * percentAlong
      my = from.y + (to.y - from.y) * percentAlong
      dx = from.x - to.x
      dy = from.y - to.y
      dist = Math.sqrt(dx*dx + dy*dy)
      dx /= dist
      dy /= dist
      
      if alwaysDown && dx > 0
        dx = -dx
        dy = -dy
        
      if opposite
        dx = -dx
        dy = -dy
      
      {x: mx + offset * dy, y: my - offset * dx}
      
    createFilter: ->
      ns = "http://www.w3.org/2000/svg"
      r1 = new DOMParser().parseFromString('<svg  xmlns="' + ns + '">
        <defs>
          <filter id="getting-started-balloon-chalk" height="2" width="1.6" color-interpolation-filters="sRGB" y="-0.5" x="-0.3">
            <feTurbulence baseFrequency="0.42065" seed="115" result="result1" numOctaves="1" type="turbulence"/>
            <feOffset result="result2" dx="-5" dy="-5"/>
            <feDisplacementMap scale="8" yChannelSelector="G" in2="result1" xChannelSelector="G" in="SourceGraphic"/>
          </filter>
        </defs>
        </svg>', 'text/xml');
      
      newNode = document.importNode(r1.documentElement, true)
      document.body.appendChild(newNode)
      Balloon.createdFilter = true
      
  $.fn.gettingStartedBalloon = (options, args...) ->
    @each ->
      $this = $(this)
      data = $this.data('plugin_gettingStartedBalloon')
      if !data
        $this.data 'plugin_gettingStartedBalloon', (data = new Balloon($this, options))

        
)(jQuery, window)
