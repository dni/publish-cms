define [
  'backbone'
], (Backbone) ->
  class NavigationItem extends Backbone.Model
    defaults:
      "label": "Navigation Item"
      "route": ""
      "classNames": ""
      "button": 0
