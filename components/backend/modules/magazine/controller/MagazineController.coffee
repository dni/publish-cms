define [
  'cs!App'
  'cs!Router'
  'cs!utils'
  'marionette'
  'cs!modules/magazine/view/MagazineLayout'
  'cs!modules/magazine/view/MagazineListView'
  'cs!utilities/views/TopView'
  'cs!modules/magazine/model/Magazine'
  'cs!modules/magazine/model/Magazines'
  'cs!modules/pages/model/Pages'
  'cs!modules/files/model/Files'
  'i18n!modules/magazine/nls/language.js'
  'cs!utilities/views/EmptyView'
], ( App, Router, Utils, Marionette, MagazineLayout, MagazineListView, TopView, Magazine, Magazines, Pages, Files, i18n, EmptyView) ->

  class MagazineController extends Marionette.Controller
    detailsMagazine: (id) ->
      magazine = App.Magazines.findWhere _id: id
      if magazine
        pages = new Pages
        pages.fetch
          data:
            magazine:id
        Utils.Vent.trigger 'app:updateRegion', "contentRegion", new MagazineLayout
          model: magazine
          files: new Files App.Files.where relation: "magazine:"+id
          pages: pages
      else
        Utils.Vent.trigger 'app:updateRegion', "contentRegion", new EmptyView message: i18n.emptyMessage

    addMagazine: ->
      Utils.Vent.trigger 'app:updateRegion', 'contentRegion', new MagazineLayout
        model: new Magazine
        files: new Files()
        pages: new Pages()

    magazines: ->
      Utils.Vent.trigger 'app:updateRegion', 'listTopRegion', new TopView navigation: i18n.navigation, newModel: 'newMagazine'
      Utils.Vent.trigger 'app:updateRegion', 'listRegion', new MagazineListView collection: App.Magazines
