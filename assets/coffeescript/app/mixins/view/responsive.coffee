###
Backbone Responsive View Mixin v1.0.0 - Backbone wrapper for enquire.js
Copyright (c) 2012 Ned Schwartz - https://github.com/theinterned/backbone-responsive-view
License: MIT (http://www.opensource.org/licenses/mit-license.php)
###

define( [
  'underscore'
  'enquire'
  ], 
  (_, Enquire) ->

    ###*
    A Backbone.js view mixin that integrates Enquire.js and allows declaritive 
    media query callbacks in a style that should be comfortable to those familiar 
    with Backbone Views DOM event handling.

    See https://github.com/theinterned/backbone-responsive-view for docs and examples

    @module ResponsiveView
    @extensionfor Backbone.View
    @requires underscore
    @requires enquire.js
    ###
    ResponsiveViewMixin =
      ###*
      Registers media query callback handlers
      
      Call this method somewhere in your View (most likey in your initialize or
      render method) to set up the breakpoint observers
      
      By default looks for a preoperty of the View called `breakpoints`, however
      this can be overriden when calling by passing either an object, 
      a refernce to an objector (eg another property or a variable that 
      holds an object) or different property name as a string.
      
      The breakpoints object should be a hash of `"<breakpoint>":<handler>` pairs 
      where handler can be an object (an enquire.js handler object), a callback 
      function (executed when the breakpiont matches) or the name of a member
      method as a string
      
      @method enquire
      @chainable
      @param  [breakpoints=this.breakpoints] {Object || String || Boolean} media 
              query hash - By default looks for a member property called 
              `breakpoints`. Otherwise can be a passed object, the string name
              of an alternate member property to use. Set to `true` to alow using 
              the default value while supplying options in the second argument
      @param  [options.listen=true] {Boolean} If set to false don't start 
              listening for screen width and orientation changes via 
              enquire.listen 
      ###   
      enquire: (breakpoints = @breakpoints, options) ->
        settings = _.extend { listen:true }, options
        breakpoints = @_getBreakpoints breakpoints
        return unless typeof breakpoints is "object"

        console.log "enquiring", breakpoints
        for breakpoint, handler of breakpoints
          if typeof handler is "string"
            handler = @[handler]
          else if typeof handler is "object"
            for method in ['match', 'unmatch', 'setup', 'destroy']
              handler[method] = @[handler[method]] if typeof handler[method] is "string"
          Enquire.register(breakpoint, handler)

        Enquire.listen() if breakpoints and settings.listen
        return @

      ###*
      sets up listeners for resize and orientation events, useful if you called
      `enquire()` with `options.listen = false`. Delegates to `enquire.listen()`.
      
      @method enquireListen
      @chainable
      @param [delay=500] {int} the time (in milliseconds) after which the queries should be handled
      ###
      enquireListen: (delay=500) -> 
        Enquire.listen(delay)
        return @

      ###*
      Tests all media queries and calls relevant methods depending whether
      transitioning from unmatched->matched or matched->unmatched. Delegates to
      `enquire.fire()`.
      
      @method enquireFire
      @chainable
      @param [e] {Event} if fired as a result of a browser event,
      an event can be supplied to propagate to the various media query handlers
      ###
      enquireFire: (e) -> 
        Enquire.fire(e)
        return @

      ###*
      unregisters a all hadlers for all queries defined in `breakpoints`.
      
      @method unenquire
      @chainable
      @param  [breakpoints=this.breakpoints] {Object || String || Boolean} media 
              query hash - By default looks for a member property called 
              `breakpoints`. Otherwise can be a passed object, the string name
              of an alternate member property to use. Set to false to provide a
              a media query as the second parameter, 
              the default value while supplying options in the second argument
      @param  [breakpoint] {Stringn} specifie a single breakpoint to unregfister 
              all of its handlers simultaneously. You must pass false as the 
              first argument. Note that this is not limited to callbacks defined 
              by this view and will also nuke any callbacks for that media query 
              registered elsewhere in your app
      ###
      unenquire: (breakpoints = @breakpoints, breakpoint) ->
        if breakpoints is false 
          Enquire.unregister breakpoint
        else
          breakpoints = @_getBreakpoints breakpoints
          for breakpoint, handler of breakpoints
            if typeof handler is "string"
              handler = @[handler]
            Enquire.unregister(breakpoint, handler)
        return @

      ###*
      Used internally to determine how the breakpoints hash is being passed
      
      @private 
      @method _getBreakpoints
      @param breakpoints {Object || String || Boolean}
      ###
      _getBreakpoints: (breakpoints) ->
        breakpoints = @[breakpoints] if typeof breakpoints is "string"
        breakpoints = @breakpoints if breakpoints is true
        return breakpoints


    return ResponsiveViewMixin
)