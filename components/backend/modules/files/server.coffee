async = require "async"
auth = require './../../utilities/auth'
multiparty = require "multiparty"
fs = require "fs-extra"
dir = "./public/files/"

module.exports.setup = (app, config, setting)->
  utils = require("../../utilities/fileutils.coffee")(app, setting)

  # upload file
  app.post "/uploadFile", auth, (req,res)->
    form = new multiparty.Form uploadDir: dir
    form.parse req, (err, fields, files)->
      if err then return console.log 'formparse error', err
      async.eachSeries files['files[]'], (srcFile, done)->
        title = utils.safeFilename srcFile.originalFilename
        fs.renameSync srcFile.path, dir+title
        file = app.createModel config.moduleName
        file.setFieldValue
          "title": title
          "link": title
          "type": srcFile.headers['content-type']
        saveFile = ->
          file.save ->
            req.io.broadcast "updateCollection", config.collectionName
            done()
        if srcFile.headers['content-type'].split("/")[0] is "image"
          utils.createImages file, saveFile
        else if srcFile.headers['content-type'] is "text/csv"
          utils.importCsv file, saveFile
        else
          saveFile()
      , res.end

  # update existing files
  app.on config.moduleName+':after:put', (req, res, file)->
    title = file.getFieldValue "title"
    saveFile = ->
      file.save ->
        req.io.broadcast 'updateCollection', config.collectionName
    if crop = req.body.crop
      file.set "crop", crop
      utils.cropImage file, ->
        utils.createImages file, saveFile
    else
      utils.updateFile file, saveFile

  #create new copy of the file
  app.on config.moduleName+":after:post", (req, res, file) ->
    utils.copyFile file, ->
      req.io.broadcast "updateCollection", config.collectionName

  # clean up files after model is deleted
  app.on config.moduleName+':after:delete', (req, res, file)->
    utils.deleteFile file, ->
      res.end()

