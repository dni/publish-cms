define [
  'cs!App'
  'cs!Publish'
  "text!./configuration.json"
  "cs!utils"
  "i18n!modules/settings/nls/language.js"
  'cs!./controller/SettingsController'
  'cs!./view/TopView'
], ( App, Publish, Config, Utils, i18n, Controller, TopView ) ->

  module = new Publish.Module
    Controller: Controller
    Config: Config
    i18n: i18n

  pConfig = JSON.parse Config

  settingsready = false
  settingsToAdd = []

  Utils.Vent.on "SettingsModule:collection:ready", ->
    settingsready = true
    for setting in settingsToAdd
      createSettings setting

  Utils.Vent.on "SettingsModule:addSetting", (config, lang)->
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
