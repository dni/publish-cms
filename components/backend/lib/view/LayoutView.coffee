define [
  'cs!Publish'
  'marionette'
  'tpl!../templates/layout.html'
], (Publish, Marionette, Template) ->
  class LayoutView extends Marionette.LayoutView

    template: Template

    regions:
      'detailRegion': '.details'
      'relatedRegion': '.related'

    initialize:(args)->
      @DetailView = args.detailView
      @model = @DetailView.model
      @RelatedViews = args.RelatedViews
      @on "render", @afterRender

    showRelatedViews: =>
      @relatedRegion.show new RelatedView
        collection: new Publish.Collection @RelatedViews

    afterRender:->
      @detailRegion.show @DetailView
      # dont create subviews if model is new and there is no _id for the relation
      if !@model.isNew() then @showRelatedViews() else @model.on "sync", @showRelatedViews, @

