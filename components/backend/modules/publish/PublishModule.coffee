define [
  'cs!App'
  'cs!Publish'
  'i18n!./nls/language'
  'text!./configuration.json'
  'cs!./model/NavigationItem'
  'cs!./model/NavigationItems'
  'cs!./view/NavigationView'
  "css!lib/style/main"
  # "less!lib/style/main"
],
( App, Publish, i18n, Config, NavigationItem, NavigationItems, NavigationView)->

  # show navigation
  App.navigationRegion.show new NavigationView collection: NavigationItems

  # overlay view
  App.overlayRegion.show new Publish.View.OverlayView

  App.vent.on "publish:addNavItem", (config, i18n)->
    config.label = i18n.navigation if i18n
    NavigationItems.add new NavigationItem config
    App.NavigationItems = NavigationItems

  new Publish.Module
    Config: Config
    i18n: i18n
    disableRoutes: true

