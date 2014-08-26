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
      zip = spawn("zip", ["-r", "-", "hpub"], cwd: "./public/books/" + magazine.fields.title.value)
      res.contentType "zip"
      zip.stdout.on "data", (data) -> res.write data
      zip.on "exit", (code) ->
        if code isnt 0
          res.statusCode = 500
        res.end()

  app.on config.moduleName+":after:post", auth, (req, res, model) ->
    console.log "after:post"
    createMagazineFiles model

  app.on config.moduleName+":after:put", (req, res, model)->
    console.log "after:put"
    newName = model.fields.title.value.replace(/[^a-z0-9]/gi, '_').toLowerCase()
    oldName = null#req.body.title.value
    ## should remove oldName
    removeMagazine newName, ->
      createMagazineFiles model

  app.on config.moduleName+":after:delete", (req, res, model)->
    console.log "after:delete"
    removeMagazine model.fields.title.value

createMagazineFiles = (magazine) ->
  magazine.fields.title.value = magazine.fields.title.value.replace(/[^a-z0-9]/gi, '_').toLowerCase()
  folder = magazine.fields.title.value
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
    if cb? then cb()