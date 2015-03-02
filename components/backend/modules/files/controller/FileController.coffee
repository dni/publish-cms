define [
  'cs!App'
  'cs!Publish'
  'cs!Router'
  'jquery'
  'cs!../view/BrowseView'
  'cs!../view/TopView'
  'cs!../view/ShowFileView'
  'cs!../view/EditFileView'
  'cs!../view/PreviewView'
], ( App, Publish, Router, $, BrowseView, TopView, ShowFileView, EditFileView, PreviewView) ->

  class FileController extends Publish.Controller.LayoutController

    TopView: TopView
    RelatedViews:
      preview: PreviewView

    filterFunction: (file)->
      !file.getValue('parent')?

    routes:
      "showfile/:id": "showfile"
      "editfile/:id": "editfile"

    showfile: (id) ->
      App.overlayRegion.show new ShowFileView
        model: App.Files.findWhere _id: id

    editfile: (id) ->
      App.overlayRegion.show new EditFileView
        model: App.Files.findWhere _id: id
