# Backbone Responsive View

A Backbone.js view mixin that integrates [Enquire.js](http://wickynilliams.github.com/enquire.js/) and allows declaritive media query callbacks in a style that should be comfortable to those familiar with Backbone Views DOM event handling.

A Simple Example:

```javascript
MyView = Backbone.View.extend({

  breakpoints: {
    "screen and (max-width:320px)": "renderPhone",
    "screen and (min-width:320px)": function() { console.log("tablet"); },
    "screen and (min-width:1024px)": {
      match:      function() {  console.log("desktop"); },
      unmatch:    function() { console.log("smaller than desktop"); },
      setup:      function() { console.log("setup only called when this query matches"); },
      deferSetup: true
    },
    intiailize: function(options) {
      this.enquire()
    },
    renderPhone: function() { console.log("phone"); }
  }

});

_.extend(MyView.prototype, ResponsiveView);
```

This example shows a number of things:

1. Breakpoint callbacks can be defined in an property called `breakpoints`.
2. The `breakpoints` property is a hash in the form `{"mediaquery" : callback}` that takes a media query as a key and a handler callback as a value.
3. The `mediaquery` can be any ordinary media query and supports any media queries that are supported by Enquire.js
4. The `callback` can be one of:
  1. The name of a View's method as a string (similar to [Backbone View's DOM 'events' callbacks](http://backbonejs.org/#View-delegateEvents)).
  2. A function.
  3. Any of the acceptable handler arguments that enquire.register() can handle. [See the Enquire.js docs](http://wickynilliams.github.com/enquire.js/) for more info.
5. If the value is either the name of a method or a function it will be called whenever the media query is matched. (See the Enquire.js docs for how to supply a match and unmatch handler if you are supplying the `callback` in the thrid form)
6. To start subscribing to media query changes, you need to call `this.enquire()` somewhere in your code. Depending on how and when your view is added to the page, you will likely want to do this in either the `initialize` or `render` method of your view.