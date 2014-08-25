define [
  'cs!Publish'
  'cs!./controller/MagazineController'
], (Publish, Controller) ->
  new Publish.Module
    Controller: Controller
    Config: Config
    i18n: i18n
