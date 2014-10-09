define [
  'jquery'
  'marionette'
  'tpl!../templates/showBtn.html'
  'i18n!../nls/language'
], ($, Marionette, Template, i18n) ->

  class ShowFileView extends Marionette.ItemView
    template: Template
    templateHelpers:
      t: i18n
