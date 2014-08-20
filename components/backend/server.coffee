fs = require 'fs'
crud = require './utilities/crud'
module.exports.setup = (app)->
  app.configure ->
    # load/setup modules
    dir =  __dirname+'/modules/'
    fs.readdir dir, (err, files)->
      if err then throw err
      files.forEach (file)->
        fs.lstat dir+file, (err, stats)->
          if !err && stats.isDirectory()
            fs.exists dir+file+'/server.coffee', (exists)->
              if exists
                module = require dir+file+'/server.coffee'
                config = require dir+file+'/configuration.json'
                module.setup app, config
                if config.model then crud app, config