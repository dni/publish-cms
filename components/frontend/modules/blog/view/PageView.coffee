define [
  'jquery',
  'marionette',
  'tpl!../templates/page-item.html',
], ($, Marionette, ItemTemplate) ->

  class PageItemView extends Marionette.ItemView
    tagName: "li"
    template: ItemTemplate

  class PageView extends Marionette.CollectionView
    className:"nav navbar-nav"
    tagName: "ul"
    childView: PageItemView
