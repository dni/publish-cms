define [
  'cs!App'
  'cs!lib/controller/Controller'
  'cs!lib/view/LayoutView'
  'cs!lib/view/RelatedListView'
], ( App, Controller, LayoutView, RelatedView ) ->
  class LayoutController extends Controller

    constructor: (args)->
      super args
      unless @RelatedViews? then return c.l "no related Views, try to specify RelatedViews, or simply use the Standard Controller"
      unless @LayoutView? then @LayoutView = LayoutView
      unless @RelatedView? then @RelatedView = RelatedView

    getContentView:(model)->
      model = @createNewModel() unless model?
      @newLayoutView model

    newRelatedView:(model)->
      new @RelatedView
        model: model
        RelatedViews: @RelatedViews

    newLayoutView:(model)->
      detailView = @newDetailView model
      relatedView = @newRelatedView model
      new @LayoutView
        detailView: detailView
        relatedView: relatedView
