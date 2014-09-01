define [
  'cs!App'
  'cs!Publish'
  'cs!Router'
  'i18n!../nls/language.js'
  'marionette'
  'tpl!../templates/related.html'
  'tpl!../templates/related-item.html'
], (App, Publish, Router, i18n, Marionette, Template, ItemTemplate) ->

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
      Router.navigate 'filebrowser/'+@model.get("_id"), trigger:true

    initialize:(args)->
      @collection = new Publish.Collection App.Files.where "fields.relation.value":@model.get "_id"
      @listenTo App.Files, "sync", @sync

    sync: =>
      files = App.Files.where "fields.relation.value": @model.get "_id"
      @collection.reset files
      @render()
