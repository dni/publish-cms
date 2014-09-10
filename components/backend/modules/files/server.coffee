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
  types = ["thumbnail", "smallPic", "bigPic", "link"]

  Setting.findOne("fields.title.value": cfg.moduleName).exec (err, setting) ->
    moduleSetting = setting

  app.on cfg.moduleName+':after:put', (req, res, file)->
    title = file.getFieldValue "title"
    if req.params.crop
      gmImg = gm(dir+title)
      crop = req.body.crop
      gmImg.size (err, size)->
        return if err
        Setting.findOne("fields.title.value": cfg.moduleName).exec (err, setting) ->
          moduleSetting = setting
          ratio = size.width / crop.origSize.w
          gmImg.crop(crop.w*ratio, crop.h*ratio, crop.x*ratio, crop.y*ratio)
          gmImg.write dir+title, ->
            createImages file, req
    else
      link = file.getFieldValue "link"
      if title != link
        if fs.existsSync(dir+title) is true
          title = title.replace ".", "_"+Date.now()+"_copy."
          file.setFieldValue "title", title
        file.setFieldValue "link", title
        copyImages file, true # move = true, only moving
      file.save ->
        req.io.broadcast 'updateCollection', cfg.collectionName


  app.post "/uploadFile", auth, (req,res)->
    form = new multiparty.Form
    form.parse req, (err, fields, files)->
      if err then return console.log 'formparse error', err
      files['files[]'].forEach (srcFile)->

        title = srcFile.originalFilename
        if fs.existsSync(dir+title) is true
          title = title.replace ".", "_"+Date.now()+"_copy."
        fs.renameSync srcFile.path, dir+title

        file = utils.createModel File, cfg
        file.setFieldValue
          title: title
          link: title
          type: srcFile.headers['content-type']


        if srcFile.headers['content-type'].split("/")[0] is "image"
          createImages file, req
        else
          file.save ->
            req.io.broadcast "updateCollection", cfg.collectionName

    res.send "success"

  #create new copy of the file
  app.on cfg.moduleName+":after:post", (req, res, file) ->
    oldFileName = file.getFieldValue "title"
    newFileName = 'new_'+Date.now()+oldFileName
    fs.writeFileSync dir+newFileName, fs.readFileSync dir+oldFileName
    file.setFieldValue 'title', newFileName
    file.setFieldValue 'link', newFileName
    copyImages file
    file.save ->
      req.io.broadcast "updateCollection", "Files"

  # clean up files after model is deleted
  app.on cfg.moduleName+':after:delete', (req, res, file)->
    for type in types
      fs.unlink "./public/files/"+file.fields[type].value

  copyImages = (file, move)->
    for type in types
      newName = file.getFieldValue type
      newName = newName.replace '\$.', '_copy_'+Date.now()+'.'
      if move
        fs.renameSync dir+newName, dir+file.getFieldValue(type)
      else
        fs.writeFileSync dir+newName, fs.readFileSync dir+file.getFieldValue type

      file.setFieldValue type, newName

  createImages = (file, req) ->
    filename = file.getFieldValue "title"
    portrait = false
    types = ["thumbnail","smallPic","bigPic"]
    image = gm(dir+filename).size (err, size) ->
      if err then return console.error "createWebPic getSize err=", err
      portrait = true if size.width < size.height
      addFile = (type, cb)->
        maxSize = moduleSetting.fields[type].value
        targetName = filename.replace '.', '_'+type+'.'
        file.setFieldValue type, targetName
        image.quality parseInt(moduleSetting.fields.quality.value)
        if portrait then image.resize null, maxSize
        else image.resize maxSize
        image.write dir+targetName, (err) ->
          file.save ->
            cb()
      async.each types, addFile, ->
        req.io.broadcast "updateCollection", cfg.collectionName
