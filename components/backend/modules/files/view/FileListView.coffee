define [
  'cs!App'
  'cs!Publish'
], (App, Publish ) ->

  class FileListView extends Publish.View.ListView
    collectionFilter: (file)->
      file.getValue("parent")?
