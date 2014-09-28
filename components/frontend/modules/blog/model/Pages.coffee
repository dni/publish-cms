define ["backbone","cs!./Page"], (Backbone, Page) ->
  class Pages extends Backbone.Collection
    model: Page
    url: "/publicpages/"

  new Pages
