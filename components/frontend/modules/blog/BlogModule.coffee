define [
  'jquery'
  'cs!utilities/App'
  'cs!utilities/Router'
  'cs!./controller/BlogController'
  'cs!./view/BlockView'
  'cs!./view/ListView'
  'cs!./model/Articles'
  'cs!./model/StaticBlocks'
  "less!./style/frontend"
],
($, App, Router, Controller, BlockView, ListView, Articles, Blocks ) ->

  App.isMobile = ()->
    userAgent = navigator.userAgent or navigator.vendor or window.opera
    return ((/iPhone|iPod|iPad|Android|BlackBerry|Opera Mini|IEMobile/).test(userAgent))

  Articles.fetch
    success:->

  Router.processAppRoutes new Controller,
    "": "list",
    "article/:id": "details"
    "category/:name": "filterCategory"

  App.addRegions
    contentRegion:"#list"

  App.BlockView = new BlockView collection: Blocks

  $ ->
    blocks = $.map $('[block]'), (o) -> $(o).attr 'block'
    Blocks.fetch
      data:
        blocks:blocks
      success: ->


