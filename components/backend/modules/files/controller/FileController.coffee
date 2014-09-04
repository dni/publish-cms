define [
  'cs!App'
  'cs!Publish'
  'cs!Router'
  'jquery'
  'cs!../view/FileListView'
  'cs!../view/BrowseView'
  'cs!../view/TopView'
  'cs!../view/ShowFileView'
  'cs!../view/EditFileView'
  'cs!../view/PreviewView'
], ( App, Publish, Router, $, ListView, BrowseView, TopView, ShowFileView, EditFileView, PreviewView) ->

  class FileController extends Publish.Controller.LayoutController

    RelatedViews:
      preview: PreviewView

    routes:
      "showfile/:id": "showfile"
      "editfile/:id": "editfile"

    showfile: (id) ->
      App.overlayRegion.show new ShowFileView
        model: App.Files.findWhere _id: id

    editfile: (id) ->
      App.overlayRegion.show new EditFileView
        model: App.Files.findWhere _id: id

    list: ->
      App.listTopRegion.show new TopView
      @collection = new Publish.Collection
      files = App.Files.filter (file)=>
        return file.attributes.fields.parent.value?
      @collection.reset files
      @listenTo App.Files, "sync", @sync
      App.listRegion.show new ListView
        collection: @collection
