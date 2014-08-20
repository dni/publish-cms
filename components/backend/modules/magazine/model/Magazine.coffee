define [
  'backbone'
], (Backbone) ->
  class Magazine extends Backbone.Model
    idAttribute: "_id"
    urlRoot: "magazines"
    defaults:
      "_id": undefined
      "title": "Neues Magazine"
      "product_id": "app.dnilabs.org.publish.magazine"
      "info": ""
      "author": "default author"
      "theme": "default"
      "editorial": "Hello World!"
      "impressum": "dnilabs"
      "published": false
      "papersize": "A4"
      "orientation": "horizontal"

    togglePublish: ->
      @.set "published", not @.get "published"
