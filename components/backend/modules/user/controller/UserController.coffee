define [
  'cs!Publish'
], (Publish) ->
  class UserController extends Publish.Controller.Controller

    routes:
      "General": "logout"

    logout: ->
      if confirm @i18n.confirmLogout then window.location = window.location.origin + '/logout'
