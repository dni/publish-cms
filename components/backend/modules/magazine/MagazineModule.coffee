define [
    'cs!App'
    'cs!Router'
    'cs!utils'
    'i18n!modules/magazine/nls/language.js'
    "text!modules/magazine/configuration.json"
    'cs!modules/magazine/controller/MagazineController'
    'cs!modules/magazine/model/Magazines'
    'less!./magazine.less'
], ( App, Router, Utils, i18n, Config, Controller, Magazines ) ->

  App.Magazines = new Magazines
  App.Magazines.fetch
    success:->

  Router.processAppRoutes new Controller,
    "newMagazine": "addMagazine"
    "magazine/:id": "detailsMagazine"
    "magazines": "magazines"

  Utils.addModule Config, i18n