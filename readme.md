# Backbone Responsive View

A [Backbone.js](http://backbonejs.org) view mixin that integrates [Enquire.js](http://wickynilliams.github.com/enquire.js/) and allows declaritive media query callbacks in a style that should be comfortable to those familiar with Backbone Views DOM event handling.

## A Simple Example:

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
    renderPhone: function() { console.log("phone"); },
    remove: function() { 
      this.unenquire();
      this.$el.remove();
    }
  }

});

_.extend(MyView.prototype, ResponsiveView);
```

This example shows a number of things:

1. Breakpoint callbacks can be defined in a property called `breakpoints` *(line 3)*.
2. The `breakpoints` property is a hash in the form `{"mediaquery" : callback}` that takes a media query as a key and a handler callback as a value.
3. The `mediaquery` can be any ordinary media query and supports any media queries that are supported by Enquire.js
4. The `callback` can be one of:
  1. The name of a View's method as a string (similar to [Backbone View's DOM 'events' callbacks](http://backbonejs.org/#View-delegateEvents)) *(line 4)*.
  2. A function *(line 5)*.
  3. Any of the acceptable handler arguments that enquire.register() can handle *(lines 6 — 11)*. [See the Enquire.js docs](http://wickynilliams.github.com/enquire.js/) for more info.
5. If the value is either the name of a method or a function it will be called whenever the media query is matched. (See the Enquire.js docs for how to supply `match` and `unmatch` handlers if you are supplying the `callback` in the thrid form).
6. To start subscribing to media query changes, you need to call `this.enquire()` somewhere in your code *(line 13)*. Depending on how and when your view is added to the page, you will likely want to do this in either the `initialize` or `render` method of your view.
7. You can unsubscribe from media query changes by calling `this.unenquire()` *(line 17)*. This delegates to enquire.js' `enquire.unregister(mediaquery, callback)` for each query handler in `this.breakpoints` (see below for more).

## Going a little deeper

### `ResponsiveView.enquire(breakpoints, options)`

`ResponsiveView.enquire()` takes an optional argument: `breakpoints`. `breakpoints` can either be the string name of a member property to use as the 'breakpoints' hash or a `breakpoints` hash can be supplied directly. If no argument is supplied then ResponsiveView will look for a property called `breakpoints` (the default behaviour). Finally, you can pass `true` as the first argument to `ResponsiveView.enquire()` which tells ResponsiveView to use the `breakpoints` member property (this is useful for passing options in the second argument to enquire);

Behind the scenes, a call to ResponsiveView.enquire() does two things:

1. Registeres all the callbacks supplied in `breakpoints` with Enquaire.js
2. calls `enquire.listen()` (and implicitly `enquire.fire()`) to start listening for viewport changes.

If, for whatver reason, you don't want to start listening for viewport changes right away, or you want to fire the callbacks yourself, you can pass `{ listen : false }` as the second argument to `ResponsiveView.enquire()`:

```javascript
this.enquire(true, {listen:false});
```

### `ResponsiveView.enquireListen(delay=500ms)` ###

If you have have declined to listen for viewport changes by passing `{listen : false}` to ResponsiveView.enquire, then you will have to manually start listening for viewport changes by calling `ResponsiveView.enquireListen()`. `enquireListen` takes one optional argument, `delay`,  which is the number of millisconds to wait for there to be no resize or orientation events before firing the media queries (just as in Enquire.js).

### `ResponsiveView.enquireFire()` ###

Simply delegates to `enquire.fire()` to evaluate each registered media query immediately.

### `ResponsiveView.unenquire(breakpoints, breakpoint)` ###

`ResponsiveView.unenquire()` delegates to `enquire.unregister()`. By default `unenquire`, called with no arguments, will loop through all the query handlers in `this.breakpoints` and call enquire.unregister(key, value) on each one.

You may supply a different `breapoints` hash as the optional first argument. This can take any of the forms outlined above for `ResponsiveView.enquire(breakpoints)`. 

If you pass `false` as the first argument, you can pass an individual media query to unsubscribe as the second argument. This is equivalent to calling `enquire.unregister("some media query")` (without the callback second argument) and alows you to nuke an entire media query and all its callbacks at once (note that this is not limited to callbacks defined by this view and will also nuke any callbacks for that media query registered elsewhere in your app):

```javascript
this.unenquire(false, "screen and (max-width: 500px)");
```