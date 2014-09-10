define [
  'cs!App'
  'cs!Publish'
  'cs!utilities/Utilities'
  'cs!lib/model/Collection'
  'cs!Router'
  'i18n!../nls/language.js'
  'marionette'
  'tpl!../templates/related.html'
  'tpl!../templates/related-item.html'
  'cs!./BrowseView'
  'cs!./ShowFileView'
], (App, Publish, Utilities, Collection, Router, i18n, Marionette, Template, ItemTemplate, BrowseView, ShowFileView) ->

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
      field: @field
    events:
      "click #files": "add"

    add:->
      App.overlayRegion.currentView.childRegion.show new BrowseView
        model: @model

    initialize:(args)->
      @multiple = args.multiple
      @fieldrelation = args.fieldrelation # if relatedfileview is shown in model
      @collection = Utilities.FilteredCollection App.Files
      @collection.filter (file)=>
        @model.get '_id' is file.getValue('relation') and
        @fieldrelation and file.getValue('fieldrelation') is @fieldrelation

