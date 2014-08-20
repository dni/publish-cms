define [
  'i18n!modules/publish/nls/language.js'
],
(i18n) ->

  Number::pad = (digits, signed) ->
    s = Math.abs(@).toString()
    s = "0" + s while s.length < digits
    (if @ < 0 then "-" else (if signed then "+" else "")) + s

  Date.months = [ i18n.january, i18n.february, i18n.march, i18n.april, i18n.may, i18n.june, i18n.july, i18n.august, i18n.september, i18n.october, i18n.november, i18n.december ]
  Date.weekdays = [ i18n.sunday, i18n.monday, i18n.tuesday, i18n.wednesday, i18n.thursday, i18n.friday, i18n.saturday ]

  Date.formats =
    "a": -> Date.weekdays[@getDay()].substring(0, 3)
    "A": -> Date.weekdays[@getDay()]
    "b": -> Date.months[@getMonth()].substring(0, 3)
    "B": -> Date.months[@getMonth()]
    "c": -> @toLocaleString()
    "d": -> @getDate().toString()
    "F": -> "#{@getFullYear()}-#{@getMonth() + 1}-#{@getDate()}"
    "H": -> @getHours().pad(2)
    "I": -> "#{(@getHours() % 12) || 12}"
    "j": -> @getDayOfYear()
    "L": -> @getMilliseconds().pad(3)
    "m": -> (@getMonth() + 1).pad(2)
    "M": -> @getMinutes().pad(2)
    "N": -> @getMilliseconds().pad(3)
    "p": -> if @getHours() < 12 then "AM" else "PM"
    "P": -> if @getHours() < 12 then "am" else "pm"
    "S": -> @getSeconds().pad(2)
    "s": -> Math.floor(@getTime() / 1000)
    "U": -> @getWeekOfYear()
    "w": -> @getDay()
    "W": -> @getWeekOfYear(1)
    "y": -> @getFullYear() % 100
    "Y": -> @getFullYear()
    "x": -> @toLocaleDateString()
    "X": -> @toLocaleTimeString()
    "z": -> Math.floor((z = -@getTimezoneOffset()) / 60).pad(2, true) + (Math.abs(z) % 60).pad(2)
    "Z": -> /\(([^\)]*)\)$/.exec(@toString())[1]

  Date::format = (fmt) ->
    parts = (fmt || i18n.dateformat).split "%%"
    for own char, callback of Date.formats
      r = new RegExp("%#{char}", "g")
      parts = (part.replace(r, => callback.apply(this)) for part in parts)
    parts.join "%"

  Date::getDayOfYear = -> Math.ceil((@getTime() - new Date(@getFullYear(), 0, 1).getTime()) / 24 / 60 / 60 / 1000)

  Date::getWeekOfYear = (start = 0) ->
    Math.floor((@getDayOfYear() - (start + 7 - new Date(@getFullYear(), 0, 1).getDay()) % 7) / 7) + 1