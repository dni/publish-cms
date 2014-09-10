define [
  'cs!utilities/Vent'
  'cs!utilities/Log'
  'cs!utilities/Debug'
  'cs!utilities/Viewhelpers'
  'cs!utilities/Date'
], ( Vent, Log, Debug, Viewhelpers) ->

  # return utilites, date util extens Date Object
  Utilities =
    Viewhelpers: Viewhelpers
    Vent: Vent
    Log: Log
    Debug: Debug
    FilteredCollection: (original)->
      filtered = new original.constructor
      filtered._callbacks = {}
      filtered.filter = (filterFunc)->
        if filterFunc
          items = original.filter filterFunc
        else
          items = original.models
        filtered.filterFunc = filterFunc
        filtered.reset items
      original.on "sync", ->
        filtered.filter filtered.filterFunc
      filtered

    safeString: (str)->
      str.toLowerCase().split(" ").join("-")

    isMobile: ()->
      userAgent = navigator.userAgent or navigator.vendor or window.opera
      return ((/iPhone|iPod|iPad|Android|BlackBerry|Opera Mini|IEMobile/).test(userAgent))


  # Shortcut Log
  window.log = Log

  # Global c.l for console.log
  window.c = console
  c.l = c.log

  return Utilities
