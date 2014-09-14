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
    events:
      "click #files": "add"

    add:->
      App.overlayRegion.currentView.childRegion.show new BrowseView
        model: @model
        fieldrelation: @fieldrelation

    initialize:(args)->
      # TODO add limit to add files / browseview
      @multiple = args.multiple
      @fieldrelation = args.fieldrelation # if relatedfileview is shown in model
      if @fieldrelation
        @model.set "fieldrelation", true
      else
        @model.set "fieldrelation", false
      @collection = Utilities.FilteredCollection App.Files
      @collection.filter (file)=>
        if @model.get("_id") is file.getValue "relation"
          if @fieldrelation
            c.l file.getValue('fieldrelation')
            return file.getValue('fieldrelation') is @fieldrelation
          else
            return true
        else
          return false

