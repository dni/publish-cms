define [
  'cs!App'
  'cs!Utils'
  'jquery'
], ( App, Utils, $ ) ->
  $("body").on "overlay:ok", ->
    App.vent.trigger "overlay:ok"
