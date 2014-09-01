define [
  'cs!App'
  'cs!Publish'
  'marionette'
  'i18n!modules/publish/nls/language'
  'tpl!lib/templates/overlay.html'
], (App, Publish, Marionette, i18n, Template) ->
  class OverlayView extends Marionette.CompositeView
    template: Template
    templateHelpers: ->
      vhs: Utils.Viewhelpers
      t: i18n
    events:
      "click .ok": "ok"
      "click .close": "close"
    childViewContainer: "modal-body"
    ok:->
      @childView.ok()
    close:->
      @childView.close()
