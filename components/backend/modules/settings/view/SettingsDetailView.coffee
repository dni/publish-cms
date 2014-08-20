define [
  'cs!App'
  'cs!Router'
  'cs!utils'
  'i18n!../nls/language.js'
  'jquery'
  'marionette'
  'tpl!../templates/detail.html'
  'bootstrap'
], ( App, Router, Utils, i18n, $, Marionette, Template, bootstrap) ->

  class SettingsDetailView extends Marionette.ItemView

    template: Template

    initialize:->
      @on "render", @afterRender, @

    afterRender:->
      @$el.find('[data-toggle=tooltip]').tooltip
        placement: 'right'
        container: 'body'

    reset: ->
      Utils.Log i18n.deleteSetting, 'delete',
        text: @model.get 'name'
        href: 'setting/'+@model.get 'name'

      @model.destroy
        success:->
      App.contentRegion.close()
      Router.navigate 'settings'

    save: ->
      Utils.Log i18n.updateSetting, 'update',
        text: @model.get 'name'
        href: 'setting/'+@model.get 'name'

      settings = @model.get "settings"
      @$el.find(".setting").each ->
        val = $(@).val()
        if $(@).attr("type") is "checkbox" then val = $(@).is(":checked")
        settings[$(@).attr("name")].value = val
        @

      @model.set 'settings', settings
      @model.save()