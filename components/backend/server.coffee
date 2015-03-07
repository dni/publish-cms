fs = require 'fs'
crud = require './utilities/crud'
dir =  __dirname+'/modules/'
configuration = require("./configuration.json")
modules = configuration.backend_modules.map (moduleString)-> dir+moduleString.split("/")[1]
Setting = require('./lib/model/Schema')('settings')

module.exports.setup = (app)->

  app.modules = {}
  app.collections = {}
  app.createModel = (moduleName, fields)->
    config = app.modules[moduleName].config
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
    message = app.createModel 'MessagesModule'
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
          if config.collectionName
            app.collections[config.collectionName] = config # important for import
            crud app, config
          waitFor = (done)-> # waitFor setting function ;)
            return done() unless config.settings
            Setting.findOne("fields.title.value": config.moduleName).exec (err, setting)->
              return done setting if setting
              setting = app.createModel "SettingsModule", config.settings
              setting.fields.title = type: "type", value: config.moduleName
              setting.set "fieldorder", Object.keys(config.settings).splice(1)
              setting.save ->
                console.log "created Setting", setting.getFieldValue "title"
                done setting
          waitFor (setting)->
            app.modules[config.moduleName] =
              config: config
              setting: setting
            module_server.setup app, config, setting
