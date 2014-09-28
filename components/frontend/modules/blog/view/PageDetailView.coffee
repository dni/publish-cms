define [
  'jquery'
  'marionette'
  'tpl!./../templates/page-detail.html'
  'cs!./../view/Viewhelpers'
  'fancybox'
], ( $, Marionette, Template, Viewhelpers, fancybox) ->
  class PageDetailView extends Marionette.ItemView
    template: Template
    templateHelpers: Viewhelpers
    className: "details"
    initialize:->
      @.on "render", ->
        $('.thumbnail').fancybox()
