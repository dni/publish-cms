define [
  'cs!App'
  'cs!Publish'
  'cs!lib/model/Collection'
  'cs!Router'
  'i18n!../nls/language.js'
  'marionette'
  'tpl!../templates/related.html'
  'tpl!../templates/related-item.html'
  'cs!./BrowseView'
  'cs!./ShowFileView'
], (App, Publish, Collection, Router, i18n, Marionette, Template, ItemTemplate, BrowseView, ShowFileView) ->

  class ItemView extends Marionette.ItemView
    template: ItemTemplate
    className: "preview-item"
    events:
      "click img": "showFile"
    initialize:->
      @listenTo @model, 'destroy', @close
    showFile: ->
      App.overlayRegion.currentView.childRegion.show new ShowFileView
        model: @model

  class RelatedFileView extends Marionette.CompositeView
    childView: ItemView
    childViewContainer: ".file-list"
    template: Template
    templateHelpers:
      t:i18n
    events:
      "click #files": "add"

    add:->
      collection = new Collection App.Files.where parent:undefined
      collection.each (model)->
        model.set "selected", false
      App.overlayRegion.currentView.childRegion.show new BrowseView
        model: @model
        collection: collection

    initialize:(args)->
      @multiple = true if args.multiple is true
      @collection.reset @getFiles()
      @listenTo App.Files, "sync", @sync

    sync: ->
      @collection.reset @getFiles()
      @render()

    getFiles: ->
      files = App.Files.filter (file)=>
        file.attributes.fields.relation.value is @model.get "_id"
