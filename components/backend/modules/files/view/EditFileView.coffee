define [
  'jquery'
  'jquery.jcrop'
  "cs!Router"
  'marionette'
  'tpl!../templates/editfile.html'
  'css!vendor/jcrop/css/jquery.Jcrop.css'
], ($, Jcrop, Router, Marionette, Template) ->

  class EditFileView extends Marionette.ItemView

    template: Template

    coords: {}

    initialize:->
      @on "render", @afterRender, @

    afterRender: ->
      that = @
      @$el.find("img").Jcrop
        onSelect: (coords)->
          that.coords = coords
          img = that.$el.find("img")
          that.coords.origSize =
            w: img.width()
            h: img.height()
          c.l that.coords

    events:
      "click .save": "save"
      "click .cancel": "cancel"

    cancel: ->
      $('.modal').modal('hide')
      Router.navigate "showfile/" + @model.get "_id", trigger:true

    save: ->
      @model.set
        crop: @coords
      @model.save()
      Router.navigate "showfile/" + @model.get "_id", trigger:true
