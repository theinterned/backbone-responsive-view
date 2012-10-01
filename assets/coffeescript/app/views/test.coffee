define([
  'app/base/view'
  'app/mixins/view/responsive'
  'tpl!templates/test.tpl'
  ],
  (BaseView, ResponsiveViewMixin, template) ->

    class TestView extends BaseView
      break:
        "screen and (min-width:400px)": "atFourHundredPx"
        "screen and (max-width:800px)": -> console.log "< 800px"
        "screen and (min-width:1000px)": 
          match: -> console.log "> 1000px"
          unmatch: -> console.log "< 1000px"
          setup: -> console.log "setup for screen and (min-width:1000px) called"
          deferSetup: true

      initialize: (options) ->
        @enquire("break", {listen:false}).enquireListen()
        return @
      
      render: ->
        @$el.html template( message:"Hello World!" )
        return @

      atFourHundredPx: -> console.log "> 400px"

    _.extend TestView::, ResponsiveViewMixin

    return TestView
)