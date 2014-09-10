define [
  'cs!lib/Publish'
  'marionette'
], (Publish, Marionette) ->

  class RelatedListItemView extends Marionette.ItemView
    initialize:->
      @viewName = @model.get "viewName"
      @view = @model.get "view"
    render:->
      @$el.append @view.render().el

  class RelatedListView extends Marionette.CollectionView
    childView: RelatedListItemView
