auth = require "./auth"

module.exports = (app, config)->
  Schema = require('./../lib/model/Schema')(config.dbTable)

  # crud
  app.post '/'+config.urlRoot, auth, (req, res)->
    schema = new Schema
    schema.user = app.user._id
    schema.crdate = new Date()
    schema.date = new Date()
    schema.published = req.body.published
    schema.name = req.body.name
    schema.fields = req.body.fields
    schema.fieldorder = req.body.fieldorder
    schema.save ->
      app.emit config.moduleName+':after:post', req, res, schema
      res.send schema

  app.get '/'+config.urlRoot, auth, (req, res)->
    Schema.find().limit(20).execFind (arr,data)-> res.send data

  app.put '/'+config.urlRoot+'/:id', auth, (req, res)->
    Schema.findById req.params.id, (e, schema)->
      app.emit config.moduleName+':before:put', req, res, schema
      schema.date = new Date()
      schema.fields = req.body.fields
      schema.published = req.body.published
      schema.save ->
        app.emit config.moduleName+':after:put', req, res, schema
        res.send schema

  app.delete '/'+config.urlRoot+'/:id', auth, (req, res)->
    Schema.findById req.params.id, (e, schema)->
      schema.remove ->
        app.emit config.moduleName+':after:delete', req, res, schema
        res.send 'deleted'
