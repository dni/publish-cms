Settings = require("./../../../lib/model/Schema")('settings')
createAppAssests = require './CreateAppAssets'
renderConstants = require './RenderConstants'

fs = require("fs-extra")
Emitter = require("events").EventEmitter
EE = new Emitter

module.exports.download = (req, res) ->

  EE.removeAllListeners "ready"
  tasks = ["icon", "build", "constants"]
  EE.on "ready", (task) ->
    tasks.splice tasks.indexOf(task), 1
    unless tasks.length
      # all tasks done, zip to res
      spawn = require("child_process").spawn
      zip = spawn("zip", ["-r","-","publish-baker"],cwd: "./cache")
      res.contentType "zip"
      zip.stdout.on "data", (data) -> res.write data
      zip.on "exit", (code) ->
        if code is 0 then console.log "download app zip done" else console.log "download app zip exited with code " + code
        res.end()

  Settings.findOne(name: "Baker").exec (error, setting) ->

    # delete dirty baker project
    spawn = require("child_process").spawn("rm", ["-rf", "-", "publish-baker"], cwd: process.cwd() + "/cache")
    spawn.on "exit", (code) ->
      if code isnt 0
        console.log "remove cache/publish-baker (rm) process exited with code " + code
      else
        # copy dummy baker project
        dirname = process.cwd() + "/cache/publish-baker"
        fs.copySync process.cwd() + "/baker-master", dirname

        # start image generating
        createAppAssests setting, -> EE.emit 'ready', 'icon'

        # render constant templates
        renderConstants setting, -> EE.emit "ready", "constants"

        # if standalone copy all hpubs into baker project
        if setting.settings.apptype.value is "standalone"
          files = fs.readdirSync("./public/books")
          for key of files
            file = files[key]
            continue if file is ".DS_Store" || file is ".gitignore"
            fs.copySync "./public/books/" + file + "/hpub", dirname + "/books/" + file

        EE.emit "ready", "build"
