define [
  'cs!App'
  'cs!lib/controller/Controller'
  'cs!lib/view/LayoutView'
], ( App, Controller, LayoutView ) ->
  class LayoutController extends Controller

    constructor: (args)->
      unless @RelatedViews? then return c.l "no related Views, try DetailController"
      unless args.LayoutView? then @LayoutView = LayoutView
      super args

    getNewFileCollection:->
      cloned = App.Files.clone()
      cloned.reset()
      cloned

    getContentView:(model)->
      @newLayoutView model

    newLayoutView:(model)->
      detailView = @newDetailView model
      c.l @RelatedViews, 'layoutviews?'

      new @LayoutView
        detailView: detailView
        RelatedViews: @RelatedViews

    add: ->
      detailView = @newDetailView()
      App.contentRegion.show new @LayoutView
        detailView: detailView
        files: @getNewFileCollection()
