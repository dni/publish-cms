define [
  'cs!Publish'
  'text!./configuration.json'
  'i18n!./nls/language'
  'cs!./controller/MagazineController'
], (Publish, Config, i18n, Controller) ->
  new Publish.Module
    Controller: Controller
    Config: Config
    i18n: i18n
