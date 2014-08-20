define [
    'jquery'
    'cs!utils'
    "text!./configuration.json"
    "i18n!modules/baker/nls/language.js"
],
( $, Utils, Config, i18n ) ->
  $("body").on "downloadApp", -> window.open(window.location.origin + '/downloadApp','_blank')
  Utils.addModule Config, i18n
