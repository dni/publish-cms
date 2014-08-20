define [
    'cs!App'
    'cs!Router'
    'cs!utils'
    'cs!lib/controller/Controller'
], ( App, Router, Utils, Controller) ->
  class Module
    constructor: (args)->
      @[key] = arg for key, arg of args

    init:->

      unless @Config? then return c.l "no module Config"
      unless @i18n? then return c.l "no module i18n"
      unless @Controller? then @Controller = Controller

      @Config = JSON.parse @Config
      config = @Config
      @Controller = new @Controller
        i18n: @i18n
        Config: @Config

      # collection
      if @Config.collectionName
        App[@Config.collectionName] = new @Controller.Collection

        App[@Config.collectionName].model = @Controller.Model
        App[@Config.collectionName].url = @Config.url
        App[@Config.collectionName].fetch
          success:->
            Utils.Vent.trigger config.name+":collection:ready"

      unless @disableRoutes
        # Routes from Controller
        routes = @Controller.routes || {}
        # Standard Routes
        routes[@Config.moduleName] = "list"
        routes[@Config.modelName+'/:id'] = "details"
        routes['new'+@Config.modelName] = "add"
        Router.processAppRoutes @Controller, routes

      if config.settings
        Utils.Vent.trigger 'SettingsModule:addSetting', config, @i18n

      if config.navigation is true
        Utils.Vent.trigger 'publish:addNavItem', {button:config.navigationButton, route:config.name}, @i18n
