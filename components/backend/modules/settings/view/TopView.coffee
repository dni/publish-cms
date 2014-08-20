define [
  'cs!Publish'
  'tpl!../templates/top.html'
],
(Publish, Template) ->
  class TopView extends Publish.View.TopView
    template: Template
