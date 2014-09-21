define [
  'underscore'
  'i18n!modules/publish/nls/language'
  'text!lib/templates/buttons.html'
], (_, i18n, buttonTemplate) ->

  Viewhelpers =
    formatDate: (date)->
      if date not typeof Date then date = new Date(date)
      date.format()

    renderButtons: (notpublishable, published)->
      _.template buttonTemplate, _.extend i18n, "notpublishable": notpublishable

