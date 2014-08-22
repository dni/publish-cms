define [
  'cs!lib/Publish'
  'marionette'
], (Publish, Marionette) ->

  class RelatedItemView extends Marionette.ItemView
    render:->
      @$el.append @model.get "html"

  class RelatedView extends Marionette.CollectionView
    childView: RelatedItemView
