fs = require 'fs'
crud = require './utilities/crud'
dir =  __dirname+'/modules/'
configuration = require("./configuration.json")
modules = configuration.backend_modules.map (moduleString)-> dir+moduleString.split("/")[1]
module.exports.setup = (app)->

  app.modules = {}

  app.createModel = (moduleName, fields)->
    config = app.modules[moduleName]
    fields = config.model unless fields?
    Schema = require('./lib/model/Schema')(config.dbTable)
    schema = new Schema
    schema.cruser = app.user._id if app.user
    schema.user = app.user._id if app.user
    schema.crdate = new Date()
    schema.date = new Date()
    schema.published = false
    schema.name = config.modelName
    schema.fields = fields
    return schema

  app.log = (string, type, name, additionalinfo)->
    if !additionalinfo? then additionalinfo = ''
    if !type? then type = 'log'
    if !name? then name = 'System'
    message = app.createModel 'Messages'
    message.setFieldValue
      name: name
      message: string
      type: type
      additionalinfo: additionalinfo
    message.save ->
      app.io.broadcast "message", message

  app.configure ->
    # load/setup modules
    modules.forEach (module)->
      fs.exists module+'/server.coffee', (exists)->
        if exists
          module_server = require module+'/server.coffee'
          config = require module+'/configuration.json'
          module_server.setup app, config
          app.modules[config.moduleName] = config
          if config.collectionName
            crud app, config
