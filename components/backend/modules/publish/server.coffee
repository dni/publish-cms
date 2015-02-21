auth = require "../../utilities/auth"
module.exports.setup = (app) ->

  app.get "/backupDatabase", auth, (req,res)->
    spawn = require('child_process').spawn
    mongoexport = spawn('mongodump', ['-d', app.config.dbname]).on 'exit', (code)->
      if code is 0
        res.send('backupped')
      else
        res.send('Error: while backupDatabase, code: ' + code)

  app.get "/restoreDatabase", auth, (req, res)->
    spawn = require('child_process').spawn
    mongoexport = spawn('mongorestore', [app.config.dbname], cwd: process.cwd()+'/dump').on 'exit', (code)->
      if code is 0
        res.send('restored')
      else
        res.send('Error: while restoreDatabase, code: ' + code)

