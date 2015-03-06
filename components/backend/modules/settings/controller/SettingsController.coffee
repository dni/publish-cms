define [
  'cs!Publish'
  'cs!../view/TopView'
  'jquery'
],
( Publish, TopView, $) ->
  class SettingsController extends Publish.Controller.Controller
    TopView: TopView
    routes:
      "clearCache": "clearCache"
    clearCache: ->
      $.get "/clearCache", ->
        window.location = "/"
