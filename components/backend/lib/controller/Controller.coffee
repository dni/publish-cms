define [
  'cs!App'
  'cs!utilities/Utilities'
  'marionette'
  'underscore'
  "cs!../model/Model"
  "cs!../model/Collection"
  "cs!../view/EmptyView"
  "cs!../view/TopView"
  "cs!../view/ListView"
  "cs!../view/DetailView"

], ( App, Utilities, Marionette, _, Model, Collection, EmptyView, TopView, ListView, DetailView) ->
  class Controller extends Marionette.Controller

    constructor: (args)->
      @[key] = arg for key, arg of args
      unless @Model? then @Model = Model
      unless @Collection? then @Collection = Collection
      unless @DetailView? then @DetailView = DetailView
      unless @ListView? then @ListView = ListView
      unless @TopView? then @TopView = TopView
      unless @EmptyView? then @EmptyView = EmptyView
      # why?!?!
      # @Model::urlRoot = @Config.urlRoot
      # @Model::collectionName = @Config.collectionName
      # @Collection::url = => @Config.url
      # @Collection::model = @Model


    newDetailView:(model)->
      new @DetailView
        model: model
        Config: @Config
        i18n: @i18n

    getContentView:(model)->
      model = @createNewModel() unless model?
      @newDetailView model

    defaults: ->
      defaults = {}
      for key, data in @Config.model
        defaults[key].type = data.type
        defaults[key].value = 'lolol'
        defaults[key].key = key
      return defaults

    createNewModel: ->
      fields = @Config.model
      for key, field of fields
        field.value = ""
      model = new @Model
      model.urlRoot = @Config.urlRoot
      model.collectionName = @Config.collectionName
      model.set
        fields: fields
        fieldorder: Object.keys(@Config.model)
        name: @Config.modelName
      return model

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
      FilteredCollection = Utilities.FilteredCollection App[@Config.collectionName]
      FilteredCollection.filter @filterFunction
      App.listRegion.show new @ListView
        config: @Config
        i18n: @i18n
        collection: FilteredCollection
