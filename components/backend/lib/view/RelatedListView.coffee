define [
  'cs!lib/Publish'
  'marionette'
], (Publish, Marionette) ->

  class RelatedListItemView extends Marionette.ItemView
    initialize:->
      @viewName = @model.get "viewName"
      @view = @model.get "view"
      @listenTo @view.collection, 'sync', @render
    render:->
      @$el.append @view.render().el

  class RelatedListView extends Marionette.CollectionView
    childView: RelatedListItemView
