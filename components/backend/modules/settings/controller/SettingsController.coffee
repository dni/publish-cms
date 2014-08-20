define [
  'cs!Publish'
  'cs!../view/TopView'
  'jquery'
],
( Publish, TopView, $) ->
  class SettingsController extends Publish.Controller.Controller

    constructor: (args)->
      @TopView = TopView
      super args

    routes:
      "clearCache": "clearCache"

    clearCache: ->
      $.get "/clearCache", ->
        window.location = "/admin#settings"
