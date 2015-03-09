define [
  'marionette'
  'text!configuration'
], (Marionette, configuration) ->
  modules = Object.keys(JSON.parse(configuration).backend_modules)
  new Marionette.Application
    ready:(moduleName)->
      modules.pop()
      if !modules.length
        @vent.trigger "ready"

