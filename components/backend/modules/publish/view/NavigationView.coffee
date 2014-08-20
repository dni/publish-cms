define [
  'jquery'
  'marionette'
  'tpl!../templates/nav-item.html'
],
($, Marionette, Template) ->

  class NavigationItemView extends Marionette.ItemView
    template: Template
    tagName: 'li'
    initialize:->
      if @model.get("button") then @$el.addClass "pull-right"

  class NavigationView extends Marionette.CollectionView
    tagName: "ul"
    className: "nav navbar-nav"

    childView: NavigationItemView
    events:
      "click a": "clicked"

    clicked: (e)->
      @children.each (view)->
        view.$el.removeClass "active"

      target = $(e.target) # clicked li
      if target[0].nodeName.toLowerCase() is 'a' # clicked link
        target = target.parent()
      else if target[0].nodeName.toLowerCase() is 'span' # clicked icon
        target = target.parent().parent()

      target.addClass "active"
