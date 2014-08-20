define [
  'cs!utils'
  'cs!Router'
  'marionette'
  'tpl!../templates/layout.html'
  'cs!modules/pages/view/PageMagazineListView'
  'cs!./MagazineDetailView'
  'cs!modules/files/view/PreviewView'#
  'i18n!modules/magazine/nls/language.js'

], (Utils, Router, Marionette, Template, PageListView, DetailView, PreviewView, i18n) ->

  class MagazineLayout extends Marionette.Layout

    template: Template
    templateHelpers:vhs:Utils.Viewhelpers

    regions:
      'detailRegion': '#magazine-details'
      'pageRegion': '#pages'
      'fileRegion': '.files'

    ui:
      publish: ".publish"
      title: "[name=title]"

    events:
      "click .delete": "deleteMagazine"
      "click .save": "save"
      "click .cancel": "cancel"

    save: ->
      @detailRegion.currentView.save()

    cancel: ->
      Utils.Vent.trigger 'app:closeRegion', 'contentRegion'
      Router.navigate 'magazines', trigger:true

    initialize: (args) ->
      # custom arguments dont get passed automatically
      @files = args['files']
      @pages = args['pages']
      @on "render", @afterRender, @

    afterRender:->
      @detailRegion.show new DetailView model: @model
      # dont childviews if model is new and there no _id for the relation
      if @model.isNew() then @model.once 'sync', @addChildViews, @ else @addChildViews()

    addChildViews:->
      @pageRegion.show new PageListView
        collection: @pages
        magazine: @model.get "_id"
      @fileRegion.show new PreviewView
        collection: @files
        namespace: 'magazine'
        description: i18n.fileDescription
        modelId: @model.get "_id"

    deleteMagazine: ->
      @pages.each (page)->
        page.destroy
          success:->
      @files.each (file)->
        file.destroy
          success:->
      @model.destroy
        success:->

      Utils.Vent.trigger 'app:closeRegion', 'contentRegion'

