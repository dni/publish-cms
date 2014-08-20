define [
  'cs!App'
  'cs!utils'
  'jquery'
], ( App, Utils, $ ) ->
  $("body").on "overlay:ok", ->
    App.vent.trigger "overlay:ok"
