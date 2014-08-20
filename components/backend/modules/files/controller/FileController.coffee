define [
  'cs!App'
  'cs!Publish'
  'i18n!modules/files/nls/language.js'
  'jquery'
  'cs!../view/ListView'
  'cs!../view/BrowseView'
  'cs!../view/TopView'
  'cs!../view/ShowFileView'
  'cs!../view/EditFileView'
], ( App, Publish, i18n, $, ListView, BrowseView, TopView, ShowFileView, EditFileView) ->

  class FileController extends Publish.Controller.Controller

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

      that = @
      App.vent.once 'overlay:ok', ->
        files = collection.where selected:true
        if !files.length then return $('.modal').modal('hide')
        $('.modal').modal('hide')
        eachFile = (file)->
          fields = file.get "fields"
          fields.parent.value = file.attributes._id
          fields.relation.value = id
          fields.key.value = 'default'

          newfile = that.createNewModel()
          newfile.set "name", that.Config.modelName
          newfile.set "fields", fields

          App.Files.create newfile,
            wait:true
            success: (res) ->
              if files.length
                eachFile files.pop()
        eachFile(files.pop())
