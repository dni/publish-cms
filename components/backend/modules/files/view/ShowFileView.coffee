define [
  'jquery'
  'marionette'
  'tpl!../templates/showfile.html'
], ($, Marionette, Template) ->

  class ShowFileView extends Marionette.ItemView
    template: Template
    ui:
      title: 'input[name=title]'
      description: 'textarea[name=description]'
      key: 'input[name=key]'

    events:
      "click .deleteFile": "deleteFile"
      "click .editFile": "editFile"

    deleteFile: ->
      $('.modal').modal('hide')
      @model.destroy
        success:->

    ok: ->
      @model.set
        title: @ui.title.val()
        description: @ui.description.val()
        key: @ui.key.val()
      @model.save()
