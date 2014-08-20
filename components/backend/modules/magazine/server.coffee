Magazine = require(__dirname + "/model/MagazineSchema")
fs = require("fs-extra")
auth = require './../../utilities/auth'
PrintGenerator = require(__dirname + "/generators/PrintGenerator")
HpubGenerator = require(__dirname + "/generators/HpubGenerator")

module.exports.setup = (app) ->

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

  app.get "/magazines", auth, (req, res) ->
    Magazine.find().limit(20).execFind (arr, data) ->
      res.send data

  app.post "/magazines", auth, (req, res) ->
    a = new Magazine()
    a.user = app.user.id
    a.editorial = req.body.editorial
    a.impressum = req.body.impressum
    a.cover = req.body.cover
    a.back = req.body.back
    a.author = req.body.author
    a.product_id = req.body.product_id
    a.info = req.body.info
    a.published = req.body.published
    a.papersize = req.body.papersize
    a.theme = req.body.theme
    a.orientation = req.body.orientation
    a.files = req.body.files
    a.date = new Date()
    a.title = req.body.title
    a.name = req.body.name
    a.save ->
      createMagazineFiles a, req.body.name, req.body.theme
      res.send a

  app.put "/magazines/:id", auth, (req, res) ->
    Magazine.findById req.params.id, (e, a) ->
      child_process = require("child_process").spawn
      spawn = child_process("rm", ["-r", a.name], cwd: "./public/books/")
      spawn.on "exit", (code) ->
        if code isnt 0
          res.send a
          console.log "remove Magazine " + a.name + " exited with code " + code
        else
          a.editorial = req.body.editorial
          a.impressum = req.body.impressum
          a.cover = req.body.cover
          a.back = req.body.back
          a.author = req.body.author
          a.product_id = req.body.product_id
          a.info = req.body.info
          a.published = req.body.published
          a.papersize = req.body.papersize
          a.theme = req.body.theme
          a.orientation = req.body.orientation
          a.files = req.body.files
          a.date = new Date()
          a.title = req.body.title
          a.name = req.body.name
          a.save ->
            createMagazineFiles a, req.body.name, req.body.theme
            res.send a

  app.delete '/magazines/:id', auth, (req, res)->
    Magazine.findById req.params.id, (e, a)->
      a.remove ->
        child_process = require("child_process").spawn
        spawn = child_process("rm", ["-rf", a.name], cwd: "./public/books/")
        spawn.on "exit", (code) ->
          if code is 0 then res.send 'deleted'
          else
            res.statusCode = 500
            console.log('remove book/yourmagazine (rm) process exited with code ' + code)

createMagazineFiles = (magazine, folder, theme) ->
  fs.mkdirSync "./public/books/" + folder
  fs.copySync "./components/magazine/" + theme + "/gfx", "./public/books/" + folder + "/hpub/gfx"
  fs.copySync "./components/magazine/" + theme + "/css", "./public/books/" + folder + "/hpub/css"
  fs.copySync "./components/magazine/" + theme + "/js", "./public/books/" + folder + "/hpub/js"
  fs.copySync "./components/magazine/" + theme + "/images", "./public/books/" + folder + "/hpub/images"
  HpubGenerator.generate magazine

