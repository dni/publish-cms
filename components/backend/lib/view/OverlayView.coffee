define [
  'jquery'
  'cs!App'
  'cs!Publish'
  'marionette'
  'i18n!modules/publish/nls/language'
  'tpl!lib/templates/overlay.html'
], ($, App, Publish, Marionette, i18n, Template) ->
  class OverlayView extends Marionette.LayoutView
    className:"modal"
    template: Template
    templateHelpers: ->
      t: i18n

    regions:
      childRegion: '.modal-body'

    initialize:->
      @childRegion.on "show", ->
        $(".modal").modal "show"
      @childRegion.on "empty", ->
        $(".modal").modal "hide"

    events:
      "click .ok": "ok"
      "click .cancel": "cancel"

    ok:->
      @childRegion.currentView?.ok?()
      @childRegion.empty()
      $(".modal").modal "hide"

    cancel:->
      @childRegion.empty()
      $(".modal").modal "hide"
