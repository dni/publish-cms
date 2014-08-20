define [
  'jquery'
  'i18n!modules/files/nls/language.js'
  'marionette'
  'tpl!../templates/top.html'
  'jquery.form'
], ($, i18n, Marionette, Template) ->
  class TopView extends Marionette.ItemView
    template: Template
    templateHelpers:t:i18n
    events:
      "change #upload": "uploadFile"

    uploadFile: ->
      @$el.find("#uploadFile").ajaxForm (response) ->
      @$el.find("#uploadFile").submit()

