define [
  'cs!App'
  'cs!utilities/Utilities'
  'cs!Publish'
  'text!../configuration.json'
  'cs!lib/model/Model'
  "i18n!../nls/language.js"
  'marionette'
  'tpl!../templates/page.html',
  'tpl!../templates/page-item.html',
  'jquery.ui'
], (App, Utilities, Publish, Config, Model, i18n, Marionette, Template, ItemTemplate, jqueryui) ->

  class RelatedPageChildView extends Marionette.ItemView
    template: ItemTemplate
    templateHelpers:
      t:i18n
      magazine: @model
      getArticles: -> App.Articles.toJSON()
      getLayouts: -> App.Settings.findSetting("PageModule").getValue("layout").split(",")
      getMagazineName: =>
        @magazine.getValue "title"

    ui:
      number: '.number'
      layout: '.layout'
      article: '.article'

    events:
      "click .remove": "deletePage"
      "change select": "updatePage"

    updatePage: ->
      @model.setValue
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
      newpage = new Model
      newpage.urlRoot = @Config.urlRoot
      newpage.collectionName = @Config.collectionName
      newpage.set "fields", @Config.model
      newpage.setValue
        number: @collection.length+1
        relation: @model.get "_id"
        article: App.Articles.first()?.get "_id"
      @collection.create newpage, wait:true, success: ->

    initialize:(args)->
      @Config = JSON.parse Config
      @collection = Utilities.FilteredCollection App.Pages
      @collection.filter (model)=>
        @model.get("_id") is model.getValue("relation")
      @collection.comparator = (model)->
        model.getValue "number"
      @collection.sort()
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
      @$el.find('li').each (i)->
        index = parseInt that.$el.find('li').index(@)
        number = parseInt $(@).find('.number').text()
        # shift model, because pop would give the last changes model which would be the previous loop el
        model = _.filter(that.collection.models, (m)-> parseInt(m.getValue('number')) is number).shift()
        model.setValue number: index+1
        model.save()
