define [
  'jquery',
  'marionette',
], ($, Marionette) ->

  class BlockView extends Marionette.CollectionView
    initialize:->
      @collection.forEach (model)->
        fields = model.get "fields"
        key = fields['title'].value
        el = $('[block="'+key+'"]')
        el.attr "id", key
        el.removeAttr('block')
        el.html fields['data'].value
