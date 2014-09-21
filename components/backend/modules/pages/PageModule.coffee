define [
    'cs!Publish'
    'i18n!./nls/language.js'
    "text!./configuration.json"
    'cs!./controller/PageController'
], (Publish, i18n, Config, Controller) ->
  new Publish.Module
    Controller: Controller
    Config:Config
    i18n:i18n
