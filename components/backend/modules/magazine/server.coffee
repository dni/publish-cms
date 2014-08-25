fs = require("fs-extra")
auth = require './../../utilities/auth'
PrintGenerator = require(__dirname + "/generators/PrintGenerator")
HpubGenerator = require(__dirname + "/generators/HpubGenerator")

module.exports.setup = (app, config) ->
  Magazine = require("./../../lib/model/Schema")(config.dbTable)

  app.get "/downloadPrint/:name", auth, PrintGenerator.download
  app.get "/downloadHpub/:id", auth, (req,res)->
    Magazine.findOne(_id: req.params.id).exec (err, magazine)->
      if err
        res.statusCode = 500
        res.end()
      spawn = require("child_process").spawn
      zip = spawn("zip", ["-r", "-", "hpub"], cwd: "./public/books/" + magazine.name)
      res.contentType "zip"
      zip.stdout.on "data", (data) -> res.write data
      zip.on "exit", (code) ->
        if code isnt 0
          res.statusCode = 500
        res.end()

  app.on config.moduleName+":after:post", auth, (req, res, model) ->
    createMagazineFiles model, model.name, model.theme

  app.on config.moduleName+":after:put", (req, res, model)->
    removeMagazine req.body.name, ->
      createMagazineFiles model, model.name, model.theme

  app.on config.moduleName+":after:delete", (req, res, model, cb)->
    removeMagazine model.name, cb

createMagazineFiles = (magazine, folder, theme) ->
  fs.mkdirSync "./public/books/" + folder
  fs.copySync "./components/magazine/" + theme + "/gfx", "./public/books/" + folder + "/hpub/gfx"
  fs.copySync "./components/magazine/" + theme + "/css", "./public/books/" + folder + "/hpub/css"
  fs.copySync "./components/magazine/" + theme + "/js", "./public/books/" + folder + "/hpub/js"
  fs.copySync "./components/magazine/" + theme + "/images", "./public/books/" + folder + "/hpub/images"
  HpubGenerator.generate magazine

removeMagazine = (dirname, cb)->
  child_process = require("child_process").spawn
  spawn = child_process("rm", ["-r", dirname], cwd: "./public/books/")
  spawn.on "exit", (code) ->
    if code is 0
      cb() if cb
    else
      res.send a
      console.log "remove Magazine " + dirname + " exited with code " + code


