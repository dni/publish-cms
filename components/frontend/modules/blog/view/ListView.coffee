define [
  'marionette'
  'tpl!./../templates/list-item.html'
  'cs!./../view/Viewhelpers'
], (Marionette, Template, Viewhelpers) ->

  class ListItemView extends Marionette.ItemView
    template: Template
    templateHelpers: Viewhelpers
    className: 'list-item'
    tagName: 'article'

  class ListView extends Marionette.CollectionView
    itemView: ListItemView
    className: 'list'