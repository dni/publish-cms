define [
  'cs!App'
  'cs!Publish'
  "text!./configuration.json"
  "i18n!./nls/language.js"
  'cs!./controller/SettingsController'
], ( App, Publish, Config, i18n, Controller ) ->

  module = new Publish.Module
    Controller: Controller
    Config: Config
    i18n: i18n

  pConfig = JSON.parse Config

  settingsready = false
  settingsToAdd = []

  App.vent.on "SettingsModule:collection:ready", ->
    settingsready = true
    for setting in settingsToAdd
      createSettings setting

  App.vent.on "SettingsModule:addSetting", (config, lang)->
    for key, value of lang.attributes
      module.i18n.attributes[key] = value

    if settingsready
      createSettings config
    else
      settingsToAdd.push config

  createSettings = (config)->
    setting = App.Settings.findSetting config.moduleName
    if !setting
      setting = new Publish.Model

      config.settings['title'] =
        value: config.moduleName
        type: "hidden"
        mongooseType: "String"

      setting.set "name", pConfig.modelName
      setting.set "fields", config.settings
      App.Settings.create setting

  return module
