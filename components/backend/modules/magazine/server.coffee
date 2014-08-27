fs = require("fs-extra")
auth = require './../../utilities/auth'
PrintGenerator = require(__dirname + "/generators/PrintGenerator")
HpubGenerator = require(__dirname + "/generators/HpubGenerator")

module.exports.setup = (app, config) ->
  Magazine = require("./../../lib/model/Schema")(config.dbTable)

  app.on config.moduleName+":after:post", (req, res, model) ->
    createMagazineFiles model

  app.on config.moduleName+":after:put", (req, res, model)->
    createMagazineFiles model

  app.on config.moduleName+":before:put", (req, res, model)->
    removeMagazine model.fields.name.value

  app.on config.moduleName+":after:delete", (req, res, model)->
    removeMagazine model.fields.name.value

  app.get "/downloadPrint/:name", auth, PrintGenerator.download
  app.get "/downloadHpub/:id", auth, (req,res)->
    Magazine.findOne(_id: req.params.id).exec (err, magazine)->
      if err
        res.statusCode = 500
        res.end()
      spawn = require("child_process").spawn
      zip = spawn("zip", ["-r", "-", "hpub"], cwd: "./public/books/" + magazine.fields.title.value)
      res.contentType "zip"
      zip.stdout.on "data", (data) -> res.write data
      zip.on "exit", (code) ->
        if code isnt 0
          res.statusCode = 500
        res.end()

createMagazineFiles = (magazine) ->
  console.log "createMagazineFiles"
  folder = magazine.fields.name.value
  if folder.length<=0 then console.log "i do not allow empty name/title"; folder = "emptyName"
  theme = magazine.fields.theme.value || "default"
  fs.mkdirSync "./public/books/" + folder
  fs.copySync "./components/magazine/" + theme + "/gfx", "./public/books/" + folder + "/hpub/gfx"
  fs.copySync "./components/magazine/" + theme + "/css", "./public/books/" + folder + "/hpub/css"
  fs.copySync "./components/magazine/" + theme + "/js", "./public/books/" + folder + "/hpub/js"
  fs.copySync "./components/magazine/" + theme + "/images", "./public/books/" + folder + "/hpub/images"
  HpubGenerator.generate magazine

removeMagazine = (dirname, cb)->
  console.log "removeMagazine"
  child_process = require("child_process").spawn
  spawn = child_process("rm", ["-r", dirname], cwd: "./public/books/")
  spawn.on "exit", (code) ->
    if code isnt 0
      #res.end()
      console.log "remove Magazine " + dirname + " exited with code " + code

parseSaveName = (name)-> name.replace(/[^a-z0-9]/gi, '_').toLowerCase()