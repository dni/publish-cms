define [
  'cs!App'
  'cs!../MyModule'
  'cs!Router'
  'cs!utils'
  'marionette'
  'tpl!../templates/detail.html'
  'i18n!../nls/language.js'
], (App, MyModule, Router, Utils, Marionette, Template) ->
  class MyDetailView extends Marionette.ItemView
    template: Template
    templateHelpers:
      # t: MyModule.i18n
      renderCategories: (category, func)->
        cats = (App.Settings.findWhere name:MyModule.Config.moduleName).getValue "categories"
        for cat in cats.split ','
          cat = cat.replace " ", ""
          if cat is category then func cat, 'selected' else func cat, ''

    ui:
      title: '[name=title]'
      publish: '.publish'

    events:
      'click .publish': 'publish'

    publish: ->
      if @model.get("published") then @ui.publish.addClass("btn-success").text('Publish') else @ui.publish.removeClass("btn-success").text('Unpublish')
      @model.togglePublish()
      @save()


    destroy:->
      # Utils.Log MyModule.i18n.deleteArticle, 'delete', text: @model.get 'title'
      @model.destroy success:->

    save: ->
      @model.set
        title: @ui.title.val()

      if @model.isNew()
        App[MyModule.Config.collectionName].create @model,
          wait: true
          success: (res) ->
            route = MyModule.Config.modelName+'/'+res.attributes._id
            # Utils.Log MyModule.i18n.newArticle, 'new',
              # text: res.attributes.title
              # href: route
            Router.navigate route, false
      else
        # Utils.Log MyModule.i18n.updateArticle, 'update',
          # text: @model.get 'title'
          # href:  MyModule.Config.modelName+'/'+@model.get '_id'
        @model.save()

