File = require('./../../lib/model/Schema')("files")
Setting = require('./../../lib/model/Schema')("settings")
async = require "async"
auth = require './../../utilities/auth'
utils = require './../../utilities/utils'
gm = require 'gm'
multiparty = require "multiparty"
fs = require "fs"

module.exports.setup = (app, cfg)->

  moduleSetting = ''
  dir = "./public/files/"

  Setting.findOne("fields.title.value": cfg.moduleName).exec (err, setting) ->
    moduleSetting = setting

  app.on cfg.moduleName+':after:put', (req, res, file)->
    if req.params.crop
      filename = file.fields.title.value
      gmImg = gm(dir+filename)
      crop = req.body.crop
      gmImg.size (err, size)->
        return if err
        Setting.findOne("fields.title.value": cfg.moduleName).exec (err, setting) ->
          moduleSetting = setting
          ratio = size.width / crop.origSize.w
          gmImg.crop(crop.w*ratio, crop.h*ratio, crop.x*ratio, crop.y*ratio)
          gmImg.write dir+filename, ->
            createImages file, req
    else
      title = file.fields.title.value
      link = file.fields.link.value
      if title != link
        fs.renameSync dir+link, dir+title
        file.fields.link.value = title
      file.save ->
        console.log file
        req.io.broadcast 'updateCollection', cfg.collectionName


  app.post "/uploadFile", auth, (req,res)->
    form = new multiparty.Form
    form.parse req, (err, fields, files)->
      if err then return console.log 'formparse error', err
      files['files[]'].forEach (srcFile)->

        title = srcFile.originalFilename
        if fs.existsSync(dir+title) is true
          title = title.replace ".", Date.now()+"_copy."
        fs.renameSync srcFile.path, dir+title

        file = utils.createModel File, cfg
        file.fields.type.value = srcFile.headers['content-type']
        file.fields.title.value = title


        if srcFile.headers['content-type'].split("/")[0] is "image"
          Setting.findOne("fields.title.value": cfg.moduleName).exec (err, setting) ->
            moduleSetting = setting
            createImages file, req
        else
          file.save ->
            req.io.broadcast "updateCollection", cfg.collectionName

    res.send "success"

  #create new copy of the file
  app.on cfg.moduleName+":after:post", (req, res, file) ->
    console.log req.body
    oldFileName = file.fields.title.value
    newFileName = 'new_'+Date.now()+oldFileName
    fs.writeFileSync dir+newFileName, fs.readFileSync dir+oldFileName



    if file.fields.type.value.split("/")[0] is "image"
      Setting.findOne("fields.title.value": cfg.moduleName).exec (err, setting) ->
        moduleSetting = setting
        createImages file, req
    else
      file.save ->
        req.io.broadcast "updateCollection", "Files"

  # clean up files after model is deleted
  app.on cfg.moduleName+':after:delete', (req, res, file)->
    types = ["thumbnail", "smallPic", "bigPic", "title"]
    for type in types
      fs.unlink "./public/files/"+file.fields[type].value

  createImages = (file, req) ->
    filename = file.fields.title.value
    portrait = false
    types = ["thumbnail","smallPic","bigPic"]
    image = gm(dir+filename).size (err, size) ->
      if err then return console.error "createWebPic getSize err=", err
      portrait = true if size.width < size.height
      addFile = (type, cb)->
        maxSize = moduleSetting.fields[type].value
        targetName = filename.replace '.', type+'.'
        file.fields[type].value = targetName
        image.quality parseInt(moduleSetting.fields.quality.value)
        if portrait then image.resize null, maxSize
        else image.resize maxSize
        image.write dir+targetName, (err) ->
          file.save ->
            cb()
      async.each types, addFile, ->
        req.io.broadcast "updateCollection", cfg.collectionName
