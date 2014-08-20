define [
  'marionette'
  'tpl!modules/article/templates/list-item.html'
], (Marionette, Template) ->

  class MyListItemView extends Marionette.ItemView
    template: Template
    initialize: ->
      @model.on "change", @render

  class MyListView extends Marionette.CollectionView
    itemView: MyListItemView
