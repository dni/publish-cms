define [
  'marionette'
], (Marionette) ->
  class RelatedListView extends Marionette.LayoutView
    initialize: (args)->
      @RelatedViews = args.RelatedViews
    render:->
      for name, RelatedView of @RelatedViews
        @$el.append('<div class="'+name+'"></div>')
        @addRegion name, '.'+name
        @[name].show new RelatedView
          model: @model

