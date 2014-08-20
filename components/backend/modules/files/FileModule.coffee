define [
  'cs!Publish'
  'cs!./controller/FileController'
  "i18n!modules/files/nls/language.js"
  "text!./configuration.json"
  'less!./style/browse.less'
],( Publish, Controller, i18n, Config ) ->
  new Publish.Module
    Controller: Controller
    Config: Config
    i18n: i18n
