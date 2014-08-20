define ["backbone","cs!./Article"], (Backbone, Article) ->
  class Articles extends Backbone.Collection
    model: Article
    url: "/publicarticles/"

  new Articles