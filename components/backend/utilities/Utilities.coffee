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
