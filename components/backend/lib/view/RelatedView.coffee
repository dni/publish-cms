define [
  'cs!lib/Publish'
  'tpl!lib/templates/related.html'
  'marionette'
], (Publish, Template, Marionette) ->

  class RelatedItemView extends Marionette.ItemView
    template: Template
    initialize:->
      console.log @model

  class RelatedView extends Marionette.CollectionView
    childView: RelatedItemView
