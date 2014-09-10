define [
  'cs!App'
  'cs!Publish'
  'text!../configuration.json'
  'cs!utilities/Utilities'
  'cs!lib/model/Model'
  'jquery'
  'underscore'
  'marionette'
  'tpl!../templates/browse-item.html'
  'tpl!../templates/upload.html'
], (App, Publish, Config, Utilities, Model, $, _, Marionette, Template, UploadTemplate) ->

  class ItemView extends Marionette.ItemView
    template: Template
    events:
      "click input": 'toggleSelect'
    toggleSelect: -> @model.set "selected", !@model.get "selected"

  class BrowseView extends Marionette.CollectionView
    childView: ItemView
    initialize: (args)->
      @model = args.model
      @Config = JSON.parse Config
      @fieldrelation = args.fieldrelation
      @collection = Utilities.FilteredCollection App.Files
      @collection.filter (file)->
        !file.getValue('parent')?
      @$el.prepend UploadTemplate

    events:
      "change #upload": "uploadFile"

    uploadFile: ->
      @$el.find("#uploadFile").ajaxForm (response) ->
      @$el.find("#uploadFile").submit()

    ok:->
      @collection.forEach (file)=>
        return if file.get "selected" is false
        newfile = new Model
        newfile.urlRoot = @Config.urlRoot
        newfile.collectionName = @Config.collectionName
        newfile.set _.clone file.attributes
        delete newfile.attributes._id
        newfile.setValue 'parent', file.get "_id"
        newfile.setValue 'relation', @model.get "_id"
        newfile.setValue 'fieldrelation', @fieldrelation
        newfile.setValue 'key', 'default'
        App.Files.create newfile
