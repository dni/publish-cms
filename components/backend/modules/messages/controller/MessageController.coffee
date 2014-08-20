define [
  'cs!App'
  'cs!Publish'
  'cs!../view/MessageListView'
  'cs!../view/MessageDetailView'
], ( App, Publish, ListView, DetailView) ->
  class MessageController extends Publish.Controller.Controller
    list : ->
      App.listTopRegion.show new Publish.View.TopView navigation:@i18n.navigation
      App.listRegion.show new ListView
      App.contentRegion.show new DetailView collection: App.Messages
