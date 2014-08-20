Message = require("./../../lib/model/Schema")('messages')
auth = require './../../utilities/auth'

module.exports.setup = (app, config) ->

  app.get "/messages", auth, (req, res) ->
    limit = if req.query.limit? then req.query.limit else 25
    Message.find().sort(date: -1).limit(limit).execFind (arr, data) ->
      res.send data

  app.on config.moduleName+":after:post", (req, res, message)->
    req.io.broadcast "updateCollection", config.collectionName
    req.io.broadcast "message", message

