define [
  'backbone'
  'marionette'
  'tpl!../templates/top.html'
],
(Backbone, Marionette, Template) ->

  class TopModel extends Backbone.Model
    defaults:
      navigation: 'Navigation Title'
      newModel:false
      newRoute:false
      search:false
      icon: 'plus'

  class TopView extends Marionette.ItemView
    template: Template
    initialize: (args)->
      @model = new TopModel args
