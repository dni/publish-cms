define [
  'jquery'
  'cs!utilities/App'
  'cs!utilities/Router'
  'cs!./controller/BlogController'
  'cs!./view/BlockView'
  'cs!./view/ListView'
  'cs!./view/PageView'
  'cs!./model/Articles'
  'cs!./model/StaticBlocks'
  'cs!./model/Pages'
  "less!./style/frontend"
  "css!style/jquery.fancybox.css"
],
($, App, Router, Controller, BlockView, ListView, PageView, Articles, Blocks, Pages ) ->

  App.isMobile = ()->
    userAgent = navigator.userAgent or navigator.vendor or window.opera
    return ((/iPhone|iPod|iPad|Android|BlackBerry|Opera Mini|IEMobile/).test(userAgent))

  Articles.fetch
    success:->

  Pages.fetch
    success:->

      App.navigationRegion.show new PageView collection: Pages

  Router.processAppRoutes new Controller,
    "": "list",
    "article/:id": "details"
    "page/:id": "page"
    "category/:name": "filterCategory"

  App.addRegions
    contentRegion:"#list"
    navigationRegion:"#navigation"



  $ ->
    blocks = $.map $('[block]'), (o) -> $(o).attr 'block'
    Blocks.fetch
      data:
        blocks:blocks
      success: ->
        App.BlockView = new BlockView collection: Blocks


