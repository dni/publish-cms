define [
  "cs!Publish"
  "text!./configuration.json"
  "i18n!./nls/language.js"
],
( Publish, Config, i18n ) ->
  new Publish.Module
    i18n: i18n
    Config: Config
