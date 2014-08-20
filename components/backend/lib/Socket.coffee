define [
  'cs!App'
  'cs!./model/Model'
  'cs!utils'
  'io'
], (App, Model, Utils, io ) ->

  socket = io.connect()
  socket.on "message", (msg)->
    msg = msg.fields
    msgType = ""
    msgText = msg.name.value+" "+msg.message.value
    if msg.type is "update" or msg.type.value is "message" then msgType = "info"
    else if msg.type.value is "delete" then msgType = "warn"
    else if msg.type.value is "new" then msgType = "success"
    #else if msgType is "update" then msgType = "error"
    $.notify msgText,
      className: msgType
      position:"right bottom"

  socket.on "updateCollection", (collection)->
    App[collection].fetch
      success:->

  socket.on "disconnect", ->
    # reload page for new login after server restarts/crashed
    reload = -> document.location.reload()
    setTimeout reload, 3000

  socket.on "connect", ->
    # reload page for new login after server restarts/crashed
    $.get "/user", (user)->
      App.User = new Model user

  socket.on "error", (err)->
    Utils.Log "SOCKET ERROR: " + err
