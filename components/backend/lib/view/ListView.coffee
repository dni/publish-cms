define [
  'jquery'
  'marionette'
  'tpl!../templates/list-item.html'
  'tpl!../templates/list.html'
  'cs!Utils'
  'cs!Router'
], ($, Marionette, Template, TemplateList, Utils, Router) ->
  columns=""
  class ListItemView extends Marionette.ItemView
    tagName: "tr"
    template: Template
    templateHelpers:->
      vhs: Utils.Viewhelpers
      columns: columns
    events:
      "click .ok": "selectItem"
      "click": "clicked"
    initialize: ->
      @listenTo @model, 'change', @render
    clicked: (e)->
      target = $(e.target)
      return if target.hasClass("btn") or target.hasClass("glyphicon")
      @trigger "newclick"
      @$el.addClass 'success'
      Router.navigate @model.get("name")+"/"+@model.get("_id"), trigger:true
    selectItem:->
      @$el.toggleClass 'info'

  class ListView extends Marionette.CompositeView
   childView: ListItemView
   template: TemplateList
   events:
     "click th": "clickSort"
   childViewContainer: 'tbody'
   childEvents:
     newclick: ->
       @children.forEach (child)->
         child.$el.removeClass('success')
   clickSort:(e)->
     return
     target = $(e.target)
     @collection.comparator = (item)->
       fields = item.get "fields"
       field = fields[target.attr("class")]
       return c.l "field doesnt exist" unless field
       if field.collection
         App[field.collection].findBy _id: field.value, (model)->
            model.getValue("title")
       else
         -field.getValue target.attr("class")


       -item.getValue(target.attr("class"))
     @collection.sort()
   initialize:->
     columns = ['title', 'date']
     columns = @options.config.columns if @options.config.columns
   templateHelpers:->
     i18n: @options.i18n
     columns: columns

  return ListView
