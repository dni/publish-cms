define [
  'cs!App'
  'jquery'
  'marionette'
  'tpl!../templates/browse-item.html'
  'tpl!../templates/upload-file.html'
], (App, $, Marionette, Template, UploadTemplate) ->

  class ItemView extends Marionette.ItemView
    template: Template
    events:
      "click input": 'toggleSelect'
      "click #upload": 'uploadFile'

    toggleSelect: -> @model.set "selected", !@model.get "selected"
    uploadFile: -> App.router.navigate "upl"

  class BrowseView extends Marionette.CollectionView
    childView: ItemView
    initialize: ->
      @collection.on "sync", @sync, @
      @$el.prepend UploadTemplate

    events:
      "change #upload": "uploadFile"

    uploadFile: ->
      @$el.find("#uploadFile").ajaxForm (response) ->
      @$el.find("#uploadFile").submit()

    sync: ->
      files = App.Files.where parent:undefined
      files.forEach (model)->
        model.set 'selected', false
      @collection.reset files
      @render()
