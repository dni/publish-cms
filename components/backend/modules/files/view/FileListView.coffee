define [
  'cs!App'
  'cs!Publish'
], (App, Publish ) ->

  class FileListView extends Publish.View.ListView
    initialize: ->
      @listenTo App.Files, "sync", @sync, @

    sync: ->
      files = App.Files.where "fields.parent.value":undefined
      @collection.reset files
      @render()
