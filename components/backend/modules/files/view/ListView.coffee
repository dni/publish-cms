define [
  'cs!App'
  'cs!Publish'
], (App, Publish ) ->

  class ListView extends Publish.View.ListView
    initialize: ->
      App.Files.on "sync", @sync, @

    sync: ->
      files = App.Files.where "fields.parent.value":undefined
      @collection.reset files
      @render()
