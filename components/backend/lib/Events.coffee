define [
  'cs!App'
  'jquery'
], ( App, $ ) ->
  $("body").on "overlay:ok", ->
    App.vent.trigger "overlay:ok"
