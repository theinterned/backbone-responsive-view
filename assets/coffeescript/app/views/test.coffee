define([
  'app/base/view'
  'tpl!templates/test.tpl'
  ],
  (BaseView, template) ->

    class TestView extends BaseView
      
      render: ->
        @$el.html template( message:"Hello World!" )
        return @
)