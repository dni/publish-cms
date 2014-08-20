define [
  'cs!App'
  'cs!Router'
  'i18n!modules/files/nls/language.js'
  'marionette'
  'tpl!../templates/preview.html'
  'tpl!../templates/preview-item.html'
], (App, Router, i18n, Marionette, Template, ItemTemplate) ->


  window.Router = Router
  class ItemView extends Marionette.ItemView
    template: ItemTemplate
    className: "preview-item"
    initialize:->
      @listenTo @model, 'destroy', @close

  class PreviewView extends Marionette.CompositeView
    template: Template
    templateHelpers:
      t:i18n
    itemView: ItemView
    itemViewContainer: ".file-list"

    events:
      "click #files": "add"

    add:->
      Router.navigate 'filebrowser/'+@model.get("_id"), {trigger:true}

    initialize:(args)->
      @modelId = args['modelId']
      @namespace = args['namespace']
      @description = args['description']
      @templateHelpers = _.extend @templateHelpers, description:args['description']
