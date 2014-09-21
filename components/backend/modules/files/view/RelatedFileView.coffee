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
    showFile: ->
      App.overlayRegion.currentView.childRegion.show new ShowFileView
        model: @model

  class RelatedFileView extends Marionette.CompositeView
    childView: ItemView
    childViewContainer: ".file-list"
    template: Template
    ui:
      addFile: '.addFile'

    templateHelpers:
      t:i18n
    events:
      "click @ui.addFile": "add"

    add:->
      App.overlayRegion.currentView.childRegion.show new BrowseView
        model: @model
        fieldrelation: @fieldrelation
        multiple: @multiple

    updateButton:->
      return if @multiple
      if @collection.length > 0
        @ui.addFile.hide()
      else
        @ui.addFile.show()

    initialize:(args)->
      @multiple = if args.multiple? then args.multiple else true
      @fieldrelation = args.fieldrelation # if relatedfileview is shown in model
      @model.set "fieldrelation", @fieldrelation
      @collection = Utilities.FilteredCollection App.Files
      @listenTo @, "render", @updateButton
      @collection.filter (file)=>
        if @model.get("_id") is file.getValue "relation"
          if @fieldrelation
            return file.getValue('fieldrelation') is @fieldrelation
          else
            return true
        else
          return false
      @listenTo @collection, "reset remove", @updateButton


