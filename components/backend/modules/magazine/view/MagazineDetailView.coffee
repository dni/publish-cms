define [
  'cs!App'
  'cs!Router'
  "cs!modules/settings/model/Settings"
  'cs!utils'
  'marionette'
  'tpl!../templates/detail.html'
  'i18n!modules/magazine/nls/language.js'
],
( App, Router, Settings, Utils, Marionette, Template, i18n) ->

  class MagazineDetailView extends Marionette.ItemView

    template: Template
    templateHelpers:
      t: i18n
      getThemes:->
        setting = App.Settings.findWhere name:'Magazines'
        themes = (setting.getValue 'theme').split(",")
        _.map themes, (theme)-> return theme.trim()
      isPrint:->
        setting = App.Settings.findWhere name:'Magazines'
        setting.getValue 'print'

    ui:
      title: '[name=title]'
      author: '[name=author]'
      product_id: '[name=product_id]'
      info: '[name=info]'
      impressum: '[name=impressum]'
      editorial: '[name=editorial]'
      theme: '[name=theme]'
      papersize: '[name=papersize]'
      orientation: '[name=orientation]'
      publish: '.publish'

    events:
      "change [name=title]": 'save'
      "click .publish": 'publish'
      "click #download": "downloadPrint"

    downloadPrint: ->
      window.open(window.location.origin + '/downloadPrint/' + @model.get("name"),'_blank')

    publish:->
      # before model is toggled
      if @model.get("published") then @ui.publish.addClass("btn-success").text('Publish') else @ui.publish.removeClass("btn-success").text('Unpublish')
      @model.togglePublish()
      @save()

    save: ->
      if @model.isNew() then check = 0 else check = 1
      if (App.Magazines.where title:@ui.title.val()).length > check
        @ui.title.val @ui.title.val() + '_kopie'
        return @ui.title.trigger("change")

      # set model
      @model.set
        title: @ui.title.val()
        name: Utils.safeString(@ui.title.val())
        author: @ui.author.val()
        product_id: @ui.product_id.val()
        info: @ui.info.val()
        impressum: @ui.impressum.val()
        editorial: @ui.editorial.val()
        theme: @ui.theme.val()
        papersize: @ui.papersize.val()
        orientation: @ui.orientation.val()

      if @model.isNew()

        App.Magazines.create @model,
          wait: true
          success: (res) ->
            route = 'magazine/'+res.attributes._id
            Utils.Log i18n.newMagazine, 'new',
              text: res.attributes.title
              href: route
            Router.navigate route, trigger:false
      else
        Utils.Log i18n.updateMagazine, 'update',
          text: @model.get 'title'
          href: 'magazine/'+@model.get '_id'
        @model.save()
