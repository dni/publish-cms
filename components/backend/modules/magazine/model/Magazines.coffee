define [
  "backbone"
  "cs!./Magazine"
], (Backbone, Model) ->

  class Magazines extends Backbone.Collection
    model: Model
    url: "/magazines/"
