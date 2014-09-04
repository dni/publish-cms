define [
  'cs!App'
  'cs!Publish'
  'jquery'
  'marionette'
  'tpl!../templates/browse-item.html'
  'tpl!../templates/upload.html'
], (App, Publish,$, Marionette, Template, UploadTemplate) ->

  class ItemView extends Marionette.ItemView
    template: Template
    events:
      "click input": 'toggleSelect'
    toggleSelect: -> @model.set "selected", !@model.get "selected"

  class BrowseView extends Marionette.CollectionView
    childView: ItemView
    initialize: (args)->
      @model = args.model
      @listenTo App.Files, "sync", @sync
      @$el.prepend UploadTemplate

    events:
      "change #upload": "uploadFile"

    uploadFile: ->
      @$el.find("#uploadFile").ajaxForm (response) ->
      @$el.find("#uploadFile").submit()

    sync: ->
      @files = App.Files.where parent:undefined
      @files.forEach (model)->
        model.set 'selected', false
      @collection.reset @files
      @render()

    cancel:->
      @files.forEach (file)->
        file.set 'selected', false

    ok:->
      files = @collection.where selected:true
      return unless files.length
      that = @
      files.forEach (file)->
        attributes = file.attributes
        attributes.fields.parent.value = file.get "_id"
        attributes.fields.relation.value = that.model.get "_id"
        attributes.fields.key.value = "default"
        delete attributes._id
        newfile = new Publish.Model
        newfile.urlRoot = file.urlRoot
        newfile.attributes = attributes
        App.Files.create newfile
