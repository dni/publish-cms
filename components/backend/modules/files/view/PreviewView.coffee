define [
  'marionette'
  'tpl!../templates/preview.html'
], (Marionette, Template) ->

  class PreviewView extends Marionette.ItemView
    template: Template
    events:
      "click .editFile": "editFile"
