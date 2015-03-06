async = require "async"
auth = require './../../utilities/auth'
module.exports.setup = (app, config)->
  Setting = require('../../lib/model/Schema')(config.dbTable)

  # create settings on startup if they dont exist
  app.settings = {}
  Setting.find().exec (err, settings)->
    for setting in settings
      app.settings[setting.getFieldValue('title')] = setting
    async.eachSeries Object.keys(app.modules), (moduleName, done)->
      unless app.settings[moduleName] # return if settings exist
        moduleSetting = app.modules[moduleName]
        if moduleSetting.settings? # return if settings doesnt exist in config
          setting = app.createModel config.moduleName, moduleSetting.settings
          setting.fields.title =
            type: "type"
            value: moduleName
          setting.set "fieldorder", Object.keys(moduleSetting.settings).splice(1)
          setting.save ->
            console.log "created setting: "+moduleName
            done()
        else
          console.log "no settings in config "+moduleName
          done()
      else
        console.log "setting exists in db "+moduleName
        done()

  # clear cache /rebuild
  app.get "/clearCache", auth, (req, res) ->
    app.log "cleared the cache", undefined, app.user.fields.title.value

