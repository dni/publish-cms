define [
  'cs!lib/Publish'
  'marionette'
  'tpl!../templates/layout.html'
], (Publish, Marionette, Template) ->
  class LayoutView extends Marionette.LayoutView

    template: Template

    regions:
      'detailRegion': '.details'
      'relatedRegion': '.related'

    initialize:(args)->
      @RelatedView = args.relatedView
      @DetailView = args.detailView
      @on 'render', @afterRender

    showRelatedView: =>
      @relatedRegion.show @RelatedView

    afterRender:->
      @detailRegion.show @DetailView
      # dont create subviews if model is new and there is no _id for the relation
      if !@DetailView.model.isNew() then @showRelatedView()
      else @DetailView.model.on "sync", @showRelatedView, @

