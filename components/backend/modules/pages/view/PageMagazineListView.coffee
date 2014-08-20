define [
  'cs!App'
  'cs!utils'
  'cs!Publish'
  "i18n!modules/pages/nls/language.js"
  'marionette'
  'tpl!../templates/page.html',
  'tpl!../templates/page-item.html',
  'jquery.ui'
], (App, Publish, Utils, i18n, Marionette, Template, ItemTemplate, jqueryui) ->

  class PageMagazineListItemView extends Marionette.ItemView
    template: ItemTemplate
    templateHelpers:
      getArticles: -> App.Articles.toJSON()
      getLayouts: -> App.Settings.findWhere({name: "Magazines"}).getValue("layouts").split(",")
      getMagazineName: (magazine)-> App.Magazines.findWhere(_id:magazine).get "name"

    ui:
      number: '.number'
      layout: '.layout'
      article: '.article'

    events:
      "click .remove": "deletePage"
      "change select": "updatePage"

    updatePage: ->
      @model.set
        number: @ui.number.text()
        layout: @ui.layout.val()
        article: @ui.article.val()
      @model.save()

    deletePage: ->
      @model.destroy
        success: ->

  class PageMagazineListView extends Marionette.CompositeView

    template: Template
    templateHelpers:t:i18n
    itemView: PageMagazineListItemView
    itemViewContainer: ".page-list"

    events:
      "click #addPage": 'addPage'

    addPage: ->
      page = new Publish.Model
        number: @collection.length+1
        magazine: @magazine
        article: App.Articles.first()

      @collection.create page

    initialize:(args)->
      @magazine = args['magazine']
      @listenTo @collection, 'reset', @render
      @listenTo @collection, 'sort', @render
      @listenTo @, "render", @_sortAble

    _sortAble:->
      @$el.find(".page-list").sortable(
        revert: true
        axis: "y"
        cursor: "move"
        stop: @_sortStop.bind(@)
      ).disableSelection()

    _sortStop: (event, ui)->
      that = @
      @$el.find('.number').each (i)->
        elNumber = $(@).text()
        model = that.collection.findWhere number: parseInt elNumber
        model.set "number", i+1
        model.save()

      @collection.sort()




