define( [
  'underscore'
  'lib/enquire'
  ], 
  (_, Enquire) ->
    # Call this method somewhere in your View (most likey in your initialize or
    # render method) to set up the breakpoint observers
    #
    # By default looks for a preoperty of the View called breakpoints, however
    # this can be overriden when calling by passing either an object, 
    # a refernce to an objector (eg another property or a variable that 
    # holds an object) or different property name as a string.
    #
    # The breakpoints object should be a hash of "<breakpoint>":<handler> where 
    # handler can be an object (an enquire.js handler object), a callback 
    # function (executed when the breakpiont matches) or the name of a member
    #  method as a string
    #
    # breakpoints: 
    #   
    enquire: (breakpoints = @breakpoints, options) ->
      settings = _.extend { listen:true }, options
      breakpoints = @[breakpoints] if typeof breakpoints is "string"
      breakpoints = @breakpoints if breakpoints is true
      return unless typeof breakpoints is "object"

      console.log "enquiring", breakpoints
      for breakpoint, handler of breakpoints
        if typeof handler is "string"
          handler = @[handler]
        Enquire.register(breakpoint, handler)

      Enquire.listen() if breakpoints and settings.listen
      return @
)