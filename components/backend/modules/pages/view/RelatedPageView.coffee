define [
  'cs!App'
  'cs!utilities/Utilities'
  'cs!Publish'
  "i18n!../nls/language.js"
  'marionette'
  'tpl!../templates/page.html',
  'tpl!../templates/page-item.html',
  'jquery.ui'
], (App, Utilities, Publish, i18n, Marionette, Template, ItemTemplate, jqueryui) ->

  class RelatedPageChildView extends Marionette.ItemView
    template: ItemTemplate
    templateHelpers:
      t:i18n
      getArticles: -> App.Articles.toJSON()
      getLayouts: -> App.Settings.findWhere({name: "MagazineModule"}).getValue("layouts").split(",")

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

  class RelatedPageView extends Marionette.CompositeView
    template: Template
    templateHelpers:
      t:i18n
    childView: RelatedPageChildView
    childViewContainer: ".page-list"

    events:
      "click .addPage": 'addPage'

    addPage: ->
      page = new @collection.model
        number: @collection.length+1
        magazine: @model
        article: App.Articles.first()
      @collection.create page

    initialize:(args)->
      @collection = Utilities.FilteredCollection App.Pages
      @collection.filter (model)=>
        @model.get("_id") is model.get("relation")
      @listenTo @collection, 'sort', @render
      # @listenTo @, "render", @_sortAble

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
