define [
  "backbone",
  "cs!./NavigationItem"
], (Backbone, Model) ->
  class NavItems extends Backbone.Collection
    model: Model

  # return instance
  new NavItems