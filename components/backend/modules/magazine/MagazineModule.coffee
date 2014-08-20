define [
    'cs!App'
    'cs!Router'
    'cs!Utils'
    'i18n!./nls/language.js'
    "text!./configuration.json"
    'cs!./controller/MagazineController'
    'cs!./model/Magazines'
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
