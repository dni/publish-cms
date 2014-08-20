define [
  'jquery'
  'marionette'
  'tpl!./../templates/detail.html'
  'cs!./../view/Viewhelpers'
  'fancybox'
], ( $, Marionette, Template, Viewhelpers, fancybox) ->
  class DetailView extends Marionette.ItemView
    template: Template
    templateHelpers: Viewhelpers
    className: "details"
    initialize:->
      @.on "render", ->
        $('.thumbnail').fancybox()
