(($, window) ->
  
  #
  # Balloon
  #
  class Balloon

    constructor: (@targetElement, @options) ->
      @targetIsFixed = false
      @evaluateTarget()
      @createFilter()
      @createBalloon()
      @createArrow()
      @position()

      # Setup events.
      $(window).on 'resize', =>
        @position()
      @balloon.on 'click', '.close-box', =>
        @close()
        if options['close']
          options['close'](@targetElement)
      @targetElement.on 'remove', =>
        @close() # Remove the balloon if the target goes away.
      
    evaluateTarget: ->
      # See if the target is a descendent of a fixed element. 
      elem = @targetElement[0]
      while (elem && !jQuery.nodeName(elem, "html"))
        if $(elem).css("position") == "fixed"
          @targetIsFixed = true
          break
        elem = elem.parentNode;
    
    createBalloon: ->
      @balloon = $("<div class='getting-started-balloon balloon'></div>")
      @balloon.html("<div class='close-box'>x</div>" + @options['content'])
      @balloon.css
        'z-index': @options['zIndex'] || @targetElement.zIndex() + 1 
      $("body").append(@balloon)
      if @options['width']
        @balloon.css
          width: @options['width'] + "px"
      if @targetIsFixed
        @balloon.css
          position: 'fixed'
      
    createArrow: ->
      if @targetIsFixed then style = "position: fixed;" else style = ""
   
      zIndex = if @options['zIndex'] then @options['zIndex'] + 1 else @targetElement.zIndex() + 2

      @svgContainer = d3.select("body")
        .append("div")
        .attr("class", "getting-started-balloon container")
        .attr("style", style + "z-index: #{zIndex}")
      @svg = @svgContainer.append("svg")
      @arrow = @svg.append("path")
        .attr("d", "")
        .attr("filter", "url(#getting-started-balloon-chalk)")
        .attr("class", "getting-started-balloon arrow")
  
    position: ->
      # Position the balloon.
      targetPosition = @targetElement.fixedOffset(@targetIsFixed)
      balloonOffset = @options['offset'] || 60
      balloonAngle = (if @options['angle']? then @options['angle'] else 180) * Math.PI / 180
      
      offset = @distanceToEdge(@targetElement.outerWidth(), @targetElement.outerHeight(), balloonAngle) +
        @distanceToEdge(@balloon.outerWidth(), @balloon.outerHeight(), balloonAngle) +
        balloonOffset
      
      tc = @targetCenter()
      left = tc.x + offset * Math.cos(balloonAngle) - @balloon.outerWidth() / 2
      top = tc.y + offset * Math.sin(balloonAngle) - @balloon.outerHeight() / 2
      
      @balloon.css
        top: top + "px"
        left: left + "px"
        
      # Update the arrow.
      @svg.attr("width", $(document).width() - 10).attr("height", $(document).height() - 10)
      @drawArrow()
    
    drawArrow: (from, to) ->
      origFrom = @balloonCenter()
      origTo = @targetCenter()
      
      targetInset = @options['targetInset'] || 1.0
      balloonInset = @options['balloonInset'] || 0.9
      
      # Move the points to the edge of the elements.
      from = @pointOnRectangle(origFrom, @balloon.outerWidth() * balloonInset, @balloon.outerHeight() * balloonInset, origTo)
      to = @pointOnRectangle(origTo, @targetElement.outerWidth() * targetInset, @targetElement.outerHeight() * targetInset, origFrom)
      middle = @perpendicularOffset(from, to, 0.5, 20, @options['flipLine'])
      
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
      @svgContainer.remove()
      
    balloonCenter: ->
      offset = @balloon.fixedOffset(@targetIsFixed)
      {x: offset.left + @balloon.outerWidth()/2, y: offset.top + @balloon.outerHeight()/2}
      
    targetCenter: ->
      offset = @targetElement.fixedOffset(@targetIsFixed)
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
    perpendicularOffset: (from, to, percentAlong, offset, flip = false, opposite = false) ->
      mx = from.x + (to.x - from.x) * percentAlong
      my = from.y + (to.y - from.y) * percentAlong
      dx = from.x - to.x
      dy = from.y - to.y
      dist = Math.sqrt(dx*dx + dy*dy)
      dx /= dist
      dy /= dist
      
      if flip
        dx = -dx
        dy = -dy
          
      if opposite
        dx = -dx
        dy = -dy
      
      {x: mx + offset * dy, y: my - offset * dx}
      
    distanceToEdge: (width, height, angle) ->
      c = Math.abs(Math.cos(angle));
      s = Math.abs(Math.sin(angle));
      if c * height > s * width # It crosses left or right side
        (width/2) / c
      else # Top or bottom side
        len = (height/2) / s;
      
      
    createFilter: ->
      return unless $("#getting-started-balloon-chalk").length == 0
      ns = "http://www.w3.org/2000/svg"
      r1 = new DOMParser().parseFromString('<svg xmlns="' + ns + '" style="width: 0; height: 0;">
        <defs>
          <filter id="getting-started-balloon-chalk" height="2" width="1.6" color-interpolation-filters="sRGB" y="-0.5" x="-0.3">
            <feTurbulence baseFrequency="0.42065" seed="115" result="result1" numOctaves="1" type="turbulence"/>
            <feOffset result="result2" dx="-5" dy="-5"/>
            <feDisplacementMap scale="4" yChannelSelector="G" in2="result1" xChannelSelector="G" in="SourceGraphic"/>
          </filter>
        </defs>
        </svg>', 'text/xml');
      
      newNode = document.importNode(r1.documentElement, true)
      document.body.appendChild(newNode)
      Balloon.createdFilter = true
      
  # Return the offset of an element, taking into account whether it is position:fixed.
  $.fn.fixedOffset = (isFixed) ->
    o = $(this[0])
    if isFixed
      box = this[0].getBoundingClientRect()
      {top: box.top, left: box.left}
    else
      o.offset()
      
  $.fn.gettingStartedBalloon = (options, args...) ->
    @each ->
      $this = $(this)
      data = $this.data('plugin_gettingStartedBalloon')
      if typeof options == 'string'
        data[options].apply(data, args) if data
      else if !data
        $this.data 'plugin_gettingStartedBalloon', (data = new Balloon($this, options))
        
)(jQuery, window)
