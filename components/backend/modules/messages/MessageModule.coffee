define [
    'cs!Publish'
    'cs!./controller/MessageController'
    "text!./configuration.json"
    "i18n!./nls/language.js"
    'less!./style'
],
( Publish, Controller, Config, i18n ) ->

  new Publish.Module
    Controller: Controller
    Config: Config
    i18n: i18n
