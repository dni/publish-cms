fs = require 'fs'
crud = require './utilities/crud'
dir =  __dirname+'/modules/'
configuration = require("./configuration.json")
modules = configuration.backend_modules.map (moduleString)-> dir+moduleString.split("/")[1]
module.exports.setup = (app)->
  app.configure ->
    # load/setup modules
    modules.forEach (module)->
      fs.exists module+'/server.coffee', (exists)->
        if exists
          module_server = require module+'/server.coffee'
          config = require module+'/configuration.json'
          module_server.setup app, config
          if config.collectionName then crud app, config
