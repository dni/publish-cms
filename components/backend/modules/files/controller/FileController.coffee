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
      "filebrowser/:id": "filebrowser"

    showfile: (id) ->
      App.overlayRegion.show new ShowFileView
        model: App.Files.findWhere _id: id

    editfile: (id) ->
      App.overlayRegion.show new EditFileView
        model: App.Files.findWhere _id: id

    list: ->
      App.listTopRegion.show new TopView
      App.listRegion.show new ListView
        collection: new @Collection App.Files.where parent:undefined

    filebrowser: (id)->
      collection = new @Collection App.Files.where parent:undefined
      collection.each (model)->
        model.set "selected", false

      App.overlayRegion.show new BrowseView
        collection: collection
      $('.modal').modal 'show'
      that = @
      @listenTo App.vent, 'overlay:ok', ->
        files = collection.where selected:true
        $('.modal').modal('hide')
        return unless files.length
        files.forEach (file)->
          fields = file.get "fields"
          fields.parent.value = file.get "_id"
          fields.relation.value = id
          fields.key.value = "default"
          newfile = that.createNewModel()
          newfile.set "fields", fields
          App.Files.create newfile
