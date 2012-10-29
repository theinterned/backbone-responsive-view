require.config(
  paths: 
    jquery:     'lib/jquery'
    underscore: 'lib/lowdash'
    backbone:   'lib/backbone'
    tpl: 'lib/requirejs/tpl'
    templates: '../templates'
    enquire: 'lib/enquire'
    # App:        'app'
  shim:
    'enquire':
      exports: 'enquire'
)

require [
  'backbone'
  'app/app'
  ], 
  (Backbone, App) ->
    new App()
    Backbone.history.start()