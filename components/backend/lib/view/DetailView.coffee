define [
  'cs!App'
  'cs!Publish'
  'cs!utils'
  'cs!Router'
  'marionette'
  'tpl!lib/templates/detail.html'
], (App, Publish, Utils, Router, Marionette, Template) ->

  class DetailView extends Marionette.ItemView

    initialize:(args)->
      @ui = {}
      @ui[key] = "[name="+key+"]" for key, arg of args.Config.model
      @bindUIElements()

    template: Template

    templateHelpers: ->
      vhs: Utils.Viewhelpers
      t: @options.i18n
      foreachAttribute: (fields, cb)->
        for key, attribute of fields
          cb key, attribute

    getAttributes:->
      attr = {}
      if @model.get("name") is "Setting"
        options = @options.Config.settings
        options['title'] =
          value: @options.Config.moduleName
          type: "hidden"
      else
        options = @options.Config.model

      for key, arg of options
        attr[key] =
          value: @ui[key].val()
          type: arg.type

      return attr

    events:
      "click .save": "save"
      "click .cancel": "cancel"
      "click .delete": "deleteModel"

    cancel: ->
      App.contentRegion.empty()
      Router.navigate @Config?.collectionName

    save: ->
      @model.set "name", @options.Config.modelName
      @model.set "fields", @getAttributes()
      that = @
      if @model.isNew()
        App[that.options.Config.collectionName].create @model,
          wait: true
          success: (res) ->
            route = res.attributes.name+'/'+res.attributes._id
            Utils.Log that.options.i18n.newModel, 'new',
              text: res.attributes._id
              href: route
            Router.navigate route, false
      else
        Utils.Log @options.i18n.updateModel, 'update',
          text: @model.get '_id'
          href: @model.get("name")+'/'+@model.get '_id'
        @model.save()


    deleteModel: ->
      Utils.Log @options.i18n.deleteModel, 'delete', text: @model.get '_id'
      @model.destroy
        success:->
      App.contentRegion.empty()
