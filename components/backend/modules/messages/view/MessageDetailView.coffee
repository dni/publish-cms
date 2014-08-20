define [
  'marionette'
  'tpl!../templates/list-item.html'
], (Marionette, Template) ->

  class MessageDetailItemView extends Marionette.ItemView
    tagName: 'li'
    initialize: ->
      @$el.addClass @model.get "type"
    template: Template

  class MessageDetailView extends Marionette.CollectionView
    tagName: 'ul'
    className: 'messages'
    childView: MessageDetailItemView
