MySchema = require __dirname+'/model/MySchema'
Config = require __dirname+'/configuration.json'
auth = require "../../utilities/auth"

module.exports.setup = (app)->

  app.get Config.url, auth, (req, res)->
    MySchema.find().execFind (arr, models)->
      res.send models

  app.post Config.url, auth, (req, res)->
    model = new MySchema
    model.user = app.user.id
    model.title = req.body.title
    model.published = req.body.published
    model.date = new Date()
    model.save ->
      req.io.broadcast 'updateCollection', 'MyModules'
      res.send model

  app.put Config.url+':id', auth, (req, res)->
    MySchema.findById req.params.id, (e, model)->
      model.user = app.user.id
      model.title = req.body.title
      model.published = req.body.published
      model.date = new Date()
      model.save ->
        req.io.broadcast 'updateCollection', 'MyModules'
        res.send model

  app.delete Config.url+':id', auth, (req, res)->
    MySchema.findById req.params.id, (e, model)->
      model.remove (err)->
        if err then return console.log err
        req.io.broadcast 'updateCollection', Config.collectionName
        res.send model