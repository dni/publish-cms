define [
  'marionette'
  'tpl!../templates/list-item.html'
], (Marionette, Template) ->

  class ItemView extends Marionette.ItemView
    template: Template
    initialize:->
      @model.on "change", @render

  class MagazineListView extends Marionette.CollectionView
    itemView: ItemView
