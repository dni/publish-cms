define [
  'jquery'
  'marionette'
  'tpl!../templates/showfile.html'
], ($, Marionette, Template) ->

  class ShowFileView extends Marionette.ItemView
    template: Template
    ui:
      title: 'input[name=title]'
      info: 'textarea[name=info]'
      description: 'textarea[name=description]'
      key: 'input[name=key]'
      alt: 'input[name=alt]'

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
        info: @ui.info.val()
        alt: @ui.alt.val()
        description: @ui.description.val()
        key: @ui.key.val()
      @model.save()
