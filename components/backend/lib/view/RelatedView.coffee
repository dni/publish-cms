define [
  'cs!Publish'
  'marionette'
  'tpl!../templates/layout.html'
  'cs!modules/files/view/PreviewView'
], (Publish, Marionette, Template, PreviewView) ->

  class RelatedItemView extends Marionette.Item.View

  class RelatedView extends Marionette.Collection.View
    childView: RelatedView
