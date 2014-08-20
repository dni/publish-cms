define [
  'jquery'
  'marionette'
  'tpl!../templates/showfile.html'
], ($, Marionette, Template) ->

  class ShowFileView extends Marionette.ItemView

    template: Template

    ui:
      name: 'input[name=name]'
      info: 'textarea[name=info]'
      desc: 'textarea[name=desc]'
      key: 'input[name=key]'
      alt: 'input[name=alt]'

    events:
      "click .deleteFile": "deleteFile"
      "click .editFile": "editFile"
      "blur .form-control": "save"

    deleteFile: ->
      $('.modal').modal('hide')
      @model.destroy
        success:->

    save: ->
      @model.set
        name: @ui.name.val()
        info: @ui.info.val()
        alt: @ui.alt.val()
        desc: @ui.desc.val()
        key: @ui.key.val()
      @model.save()
