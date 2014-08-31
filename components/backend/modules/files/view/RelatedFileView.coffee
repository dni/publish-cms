define [
  'cs!App'
  'cs!Router'
  'i18n!../nls/language.js'
  'marionette'
  'tpl!../templates/related.html'
  'tpl!../templates/related-item.html'
], (App, Router, i18n, Marionette, Template, ItemTemplate) ->

  class ItemView extends Marionette.ItemView
    template: ItemTemplate
    className: "preview-item"
    initialize:->
      @listenTo @model, 'destroy', @close

  class RelatedFileView extends Marionette.CompositeView
    template: Template
    templateHelpers:
      t:i18n
    childView: ItemView
    childViewContainer: ".file-list"

    events:
      "click #files": "add"

    add:->
      Router.navigate 'filebrowser/'+@model.get("_id"), trigger:true

    initialize:(args)->
      @modelId = args['modelId']
      @namespace = args['namespace']
      @description = args['description']
      @templateHelpers = _.extend @templateHelpers, description:args['description']
