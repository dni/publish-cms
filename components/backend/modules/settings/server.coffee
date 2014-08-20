auth = require './../../utilities/auth'
module.exports.setup = (app, config)->
  console.log config.dbTable
  Setting = require('../../lib/model/Schema')(config.dbTable)

  # clear cache /rebuild
  app.get "/clearCache", auth, (req, res) ->
    # grunt = require("child_process").spawn("grunt", ["reloadSettings"])
    # #grunt = require('grunt').tasks(['build']);
    # grunt.stdout.on "data", (data) -> if data isnt "" then console.log "stdout: " + data
    # grunt.stderr.on "data", (data) -> console.log "stderr: " + data
    # #grunt.on "close", (code) -> console.log "child process closed with code " + code
    # grunt.on "close", (code) ->
    #     if code isnt 0
    #       res.statusCode = 500
    #       console.lcog "grunt process exited with code " + code
    #       res.end()
    #     else
    #       console.log "grunt task done without errors"
    #       res.end()
    exec = require("child_process").exec
    child = undefined
    child = exec("grunt restart", (error, stdout, stderr) ->
      console.log "stdout: " + stdout
      console.log "stderr: " + stderr
      console.log "exec error: " + error  if error isnt null
      res.end()
    )
