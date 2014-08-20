define [
  'underscore'
  'i18n!modules/publish/nls/language.js'
  'text!lib/templates/buttons.html'
], (_, i18n, buttonTemplate) ->

  Viewhelpers =
    formatDate: (date)->
      if date not typeof Date then new Date(date)
      date.format()

    renderButtons: _.template buttonTemplate, i18n

