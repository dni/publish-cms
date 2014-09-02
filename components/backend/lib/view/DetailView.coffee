define [
  'cs!App'
  'cs!Publish'
  'cs!Utils'
  'cs!Router'
  'marionette'
  'tpl!lib/templates/detail.html'
], (App, Publish, Utils, Router, Marionette, Template) ->
  class DetailView extends Marionette.ItemView
    template: Template

    initialize:(args)->
      @model = args.model
      @notpublishable = unless args.Config.notpublishable? then false else true
      @ui = {}
      @ui[key] = "[name="+key+"]" for key, arg of @model.get "fields"
      @bindUIElements()
      @on "render", @afterRender, @

    afterRender:->
      @chPublishBtn()
      @$el.find('[data-toggle=tooltip]').tooltip
        placement: 'right'
        container: 'body'

    templateHelpers: ->
      vhs: Utils.Viewhelpers
      notpublishable: @notpublishable
      t: @options.i18n
      foreachAttribute: (fields, cb)->
        for key in @fieldorder
          cb key, fields[key]

    getValuesFromUi: ()->
      fields = @model.get "fields"
      for key, field of fields
        field.value = @ui[key].val()
      return fields

    events:
      "click .save": "save"
      "click .cancel": "cancel"
      "click .delete": "deleteModel"
      "click .publish": "togglePublish"

    togglePublish: ->
      # change text to 
      @model.togglePublish()
      @chPublishBtn()

    chPublishBtn: ->
      @$el.find(".publish.btn span").hide()
      if @model.get("published") is true then @$el.find("span.published").show()
      else @$el.find("span.unpublished").show()

    cancel: ->
      App.contentRegion.empty()
      Router.navigate @Config?.collectionName

    save: ->
      @model.set "fields", @getValuesFromUi()
      that = @
      if @model.isNew()
        App[that.options.Config.collectionName].create @model,
          wait: true
          success: (res) ->
            route = res.attributes.name+'/'+res.attributes._id
            Utils.Log that.options.i18n.newModel, 'new',
              text: res.attributes._id
              href: route
            Router.navigate route, trigger:false
      else
        Utils.Log @options.i18n.updateModel, 'update',
          text: @model.get '_id'
          href: @model.get("name")+'/'+@model.get '_id'
        @model.save()


    deleteModel: ->
      Utils.Log @options.i18n.deleteModel, 'delete', text: @model.get '_id'
      App.contentRegion.empty()
      @model.destroy
        success: ->
