define [
  'cs!App'
  'cs!lib/controller/Controller'
  'cs!lib/view/LayoutView'
  'cs!lib/view/RelatedView'
], ( App, Controller, LayoutView, RelatedView ) ->
  class LayoutController extends Controller

    constructor: (args)->
      unless @RelatedViews? then return c.l "no related Views, try DetailController"
      unless args.LayoutView? then @LayoutView = LayoutView
      unless args.RelatedView? then @RelatedView = RelatedView
      super args

    getContentView:(model)->
      model = @createNewModel() unless model?
      @newLayoutView model

    newRelatedView:(model)->
      relatedViews = []
      for viewName, RelatedView of @RelatedViews
        relatedView = new RelatedView model:model
        relatedViews.push viewName:viewName, html: relatedView.render().el
      new @RelatedView collection: new @Collection relatedViews

    newLayoutView:(model)->
      detailView = @newDetailView model
      relatedView = @newRelatedView model
      new @LayoutView
        detailView: detailView
        relatedView: relatedView

