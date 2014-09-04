define [
  'cs!App'
  'cs!Publish'
  'cs!Router'
  'i18n!../nls/language.js'
  'marionette'
  'tpl!../templates/related.html'
  'tpl!../templates/related-item.html'
  'cs!./BrowseView'
], (App, Publish, Router, i18n, Marionette, Template, ItemTemplate, BrowseView) ->

  class ItemView extends Marionette.ItemView
    template: ItemTemplate
    className: "preview-item"
    initialize:->
      @listenTo @model, 'destroy', @close

  class RelatedFileView extends Marionette.CompositeView
    childView: ItemView
    childViewContainer: ".file-list"
    template: Template
    templateHelpers:
      t:i18n

    events:
      "click #files": "add"

    add:->
      collection = new Publish.Collection App.Files.where parent:undefined
      collection.each (model)->
        model.set "selected", false
      App.overlayRegion.currentView.childRegion.show new BrowseView
        model: @model
        collection: collection

    initialize:(args)->
      @collection = new Publish.Collection
      files = App.Files.filter (file)=>
        return file.attributes.fields.relation.value == @model.get "_id"
      @collection.reset files
      @listenTo App.Files, "sync", @sync

    sync: ->
      files = App.Files.filter (file)=>
        return file.attributes.fields.relation.value == @model.get "_id"
      @collection.reset files
      @render()
