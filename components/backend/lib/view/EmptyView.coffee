define [
  'backbone'
  'marionette'
  'tpl!utilities/templates/empty.html'
],
( Backbone, Marionette, Template) ->
  class EmptyView extends Marionette.ItemView
    template: Template
    initialize:(args)->
      @model = new Backbone.Model message: args['message']
