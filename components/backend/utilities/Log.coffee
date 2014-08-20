define [
  'cs!App'
  'cs!lib/model/Model'
  'text!modules/messages/configuration.json'
  'notifyjs'
  'jquery'
], (App, Model, Config, notify, $) ->
  config = JSON.parse Config
  (log, type, additionalinfo)->
    if !additionalinfo? then additionalinfo = ''
    if !type? then type = 'log'

    config.model.message.value =  log
    config.model.name.value = App.User.attributes.fields.title.value
    config.model.type.value = type
    config.model.additionalinfo.value = additionalinfo

    message = new Model
    message.set "name", "MessageModel"
    message.set "fields", config.model
    App.Messages.create message,
      success: ->

    message
