define [
  'cs!utilities/App'
  'marionette'
  'cs!./../model/Articles'
  'cs!./../model/Pages'
  'cs!./../view/ListView'
  'cs!./../view/DetailView'
], (App, Marionette, Articles, Pages, ListView, DetailView) ->

  class BlogController extends Marionette.Controller

    list: ->
      Articles.fetch
        success:->
          App.contentRegion.show new ListView collection: Articles

    details: (id) ->
      article = Articles.findWhere _id: id
      App.contentRegion.show new DetailView model: article

    filterCategory: (name) ->
      console.log name, Articles, Articles.where category: name
      Articles.fetch
        data: category: name
        success:->
          App.contentRegion.show new ListView collection: Articles

    page: (id) ->
      page = Pages.findWhere _id: id
      App.contentRegion.show new PageDetailView model: page
