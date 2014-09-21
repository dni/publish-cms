define [
  'cs!Publish'
], (Publish)->
  class PageController extends Publish.Controller.Controller
    filterFunction: (model)->
      !model.getValue('relation')
