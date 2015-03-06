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

  App.vent.on "SettingsModule:translate", (lang)->
    for key, value of lang.attributes
      module.i18n.attributes[key] = value

  module
