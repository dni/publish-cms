define [
    'cs!Publish'
    'i18n!modules/pages/nls/language.js'
    "text!./configuration.json"
], (Publish, i18n, Config) ->
  new Publish.Module
    Config:Config
    i18n:i18n
