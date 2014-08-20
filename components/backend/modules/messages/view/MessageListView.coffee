define [
  'cs!App'
  'cs!Publish'
  'text!modules/messages/configuration.json'
  'marionette'
  'tpl!../templates/list.html'
  'i18n!modules/messages/nls/language.js'
], (App, Publish, Config, Marionette, Template, i18n) ->

  config = JSON.parse Config

  class MessageListView extends Marionette.ItemView

    template: Template
    templateHelpers: t: i18n

    events:
      "submit form": "newMessage"
      "click [name='clear']": "clearMessages"
      "change [name=limit]": "limit"

    ui:
      message: '[name=message]'
      limit:  "[name=limit]"

    limit:->
      App.Messages.fetch
        data: limit: @ui.limit.val()

    #unused
    clearMessages: ->
      messages = App.Messages.models
      if confirm i18n.confirmClear
        while model = App.Messages.first()
          model.destroy()

    newMessage: (e)->
      e.preventDefault()

      # do nothing on empty message
      if not @ui.message.val() then return

      config.model.message.value =  @ui.message.val()
      config.model.name.value = App.User.get "name"
      config.model.type.value = 'message'

      message = new Publish.Model
      message.set "name", config.modelName
      message.set "date", Date.now()
      message.set "fields", config.model

      @ui.message.val('')

      App.Messages.create message,
        success: (res) ->

      return false
