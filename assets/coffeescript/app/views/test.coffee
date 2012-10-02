define([
  'app/base/view'
  'app/mixins/view/responsive'
  'tpl!templates/test.tpl'
  ],
  (BaseView, ResponsiveViewMixin, template) ->

    class TestView extends BaseView
      removeTemplate: "<button id='remove'>Remove Media Queries</button>"
      resetTemplate:  "<button id='reset'>Reset Media Queries</button>"
      
      break:
        "screen and (min-width:500px)": "atFiveHundredPx"
        "screen and (max-width:800px)": -> console.log "< 800px"
        "screen and (min-width:1000px)": 
          match: -> console.log "> 1000px"
          unmatch: -> console.log "< 1000px"
          setup: -> console.log "setup for screen and (min-width:1000px) called"
          deferSetup: true
          destroy: -> console.log "removing handler for screen and (min-width:1000px)"

      events:
        "click #remove": "remove"
        "click #reset": "reset"

      initialize: (options) ->
        @enquire("break", {listen:false}).enquireListen()
        @enquire "screen and (min-width:500px)": -> console.log "another callback for 500px"
        return @
      
      render: ->
        @$el.html template( message:"Hello World!" )
        @$el.append @removeTemplate
        return @

      atFiveHundredPx: -> console.log "> 500px"

      remove: => 
        @unenquire "break"
        @unenquire false, "screen and (min-width:500px)"
        @$('#remove').remove()
        @$el.append @resetTemplate

      reset: =>
        @$el.html("")
        @initialize().render()

    _.extend TestView::, ResponsiveViewMixin

    return TestView
)