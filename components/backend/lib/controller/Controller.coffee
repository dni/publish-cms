define [
  'cs!App'
  'marionette'
  "cs!../model/Model"
  "cs!../model/Collection"
  "cs!../view/EmptyView"
  "cs!../view/TopView"
  "cs!../view/ListView"
  "cs!../view/DetailView"

], ( App, Marionette, Model, Collection, EmptyView, TopView, ListView, DetailView) ->
  class Controller extends Marionette.Controller

    constructor: (args)->
      @[key] = arg for key, arg of args
      unless @Model? then @Model = Model
      unless @Collection? then @Collection = Collection
      unless @DetailView? then @DetailView = DetailView
      unless @ListView? then @ListView = ListView
      unless @TopView? then @TopView = TopView
      unless @EmptyView? then @EmptyView = EmptyView

    newDetailView:(model)->
      model = @createNewModel() unless model?
      new @DetailView
        model: model
        Config: @Config
        i18n: @i18n

    getContentView:(model)->
      @newDetailView model

    defaults: ->
      defaults = {}
      for key, data in @Config.model
        defaults[key].type = data.type
        defaults[key].value = 'lolol'
        defaults[key].key = key
      return defaults

    createNewModel: ->
      fields = {}
      for key, field of @Config.model
        fields[key] =
          value: ''
          type: field.type
      model = new @Model
      model.set
        fields: fields
        name: @Config.modelName
      model.urlRoot = @Config.urlRoot
      model.collectionName = @Config.collectionName
      return model

    settings: (attr)->
      (App.Settings.findWhere name: @Config.moduleName).getValue(attr)

    details: (id) ->
      model = App[@Config.collectionName].findWhere _id: id
      if model
        view = @getContentView model
      else
        view = new @EmptyView message: @i18n.emptyMessage

      view.i18n = @i18n
      App.contentRegion.show view

    add: ->
      App.contentRegion.show @getContentView()

    list: ->
      App.listTopRegion.show new @TopView
        navigation: @i18n.navigation
        newRoute: 'new'+@Config.modelName
      App.listRegion.show new @ListView collection: App[@Config.collectionName]
