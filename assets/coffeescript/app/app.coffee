define([
  'backbone'
  'app/base/router'
  'app/views/test'
  ],
  (Backbone, Router, TestView) ->

    class App extends Router
      routes: 
        "*any": "any"
      initialize: -> 
        console.log "    hello world", @
        $('body').append new TestView().render().el
      any: (page) -> console.log '    route', page
)