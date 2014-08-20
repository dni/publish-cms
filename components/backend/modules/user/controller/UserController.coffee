define [
  'cs!Publish'
  'i18n!modules/user/nls/language.js'
], (Publish) ->
  class UserController extends Publish.Controller.Controller

    routes:
      "General": "logout"

    logout: ->
      if confirm @i18n.confirmLogout then window.location = window.location.origin + '/logout'
