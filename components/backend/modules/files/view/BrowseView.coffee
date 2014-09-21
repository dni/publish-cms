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

  class BrowseItemView extends Marionette.ItemView
    template: Template
    ui:
      item: '.browse-item'
    events:
      "click @ui.item": 'toggleSelect'

    toggleSelect: (e)->
      selected = @model.get("selected") || false
      @model.set "selected", !selected
      @ui.item.toggleClass? 'selected'


  class BrowseView extends Marionette.CollectionView
    childView: BrowseItemView
    initialize: (args)->
      @model = args.model
      @multiple = args.multiple
      @Config = JSON.parse Config
      @fieldrelation = args.fieldrelation
      @collection = Utilities.FilteredCollection App.Files
      @collection.filter (file) -> !file.getValue('parent')?
      @collection.forEach (model) => model.set "multiple", @multiple
      if !@multiple then  @listenTo @collection, 'change', App.overlayRegion.currentView.ok
      @$el.prepend UploadTemplate

    events:
      "change #upload": "uploadFile"

    uploadFile: ->
      @$el.find("#uploadFile").ajaxForm (response) -> true
      @$el.find("#uploadFile").submit()

    ok: ->
      @collection.forEach (file)=>
        selected = file.get("selected") || false
        return if selected is false
        file.set("selected", false)
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
