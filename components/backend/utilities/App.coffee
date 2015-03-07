define [
  'marionette'
  'text!configuration'
], (Marionette, configuration) ->
  modules = Object.keys(JSON.parse(configuration).backend_modules)
  new Marionette.Application
    ready:(moduleName)->
      if !modules.length then @vent.trigger "ready"
