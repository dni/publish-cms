define [
  'marionette'
  'tpl!../templates/list-item.html'
], (Marionette, Template) ->

  class ListItemView extends Marionette.ItemView
    template: Template
    initialize: ->
      @model.on 'change', @render, @

  class ListView extends Marionette.CollectionView
   childView: ListItemView

  return ListView
