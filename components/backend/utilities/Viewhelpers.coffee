define [
  'cs!App'
  'underscore'
  'i18n!modules/publish/nls/language'
  'text!lib/templates/buttons.html'
], (App, _, i18n, buttonTemplate) ->

  Viewhelpers =
    getModel: (field)->
      App[field.collection].findWhere _id: field.value

    formatDate: (date)->
      if date not typeof Date then date = new Date(date)
      date.format()

    renderButtons: (notpublishable, published)->
      _.template buttonTemplate, _.extend i18n, "notpublishable": notpublishable

