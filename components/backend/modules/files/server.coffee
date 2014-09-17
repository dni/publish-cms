File = require('./../../lib/model/Schema')("files")
Setting = require('./../../lib/model/Schema')("settings")
async = require "async"
auth = require './../../utilities/auth'
utils = require './../../utilities/utils'
gm = require 'gm'
multiparty = require "multiparty"
fs = require "fs-extra"

# caused the file errors because it is asynchronous
# file.save would workd
# multiple file upload wont work
# fs.move = (oldLink, newLink, cb)->
#   console.log("move ", oldLink, newLink)
#   fs.copy oldLink, newLink, (err)->
#     if err? then return console.log err
#     fs.unlink oldLink, (err)->
      # if err? then return console.log err
      # cb?()

module.exports.setup = (app, cfg)->
  moduleSetting = ''
  dir = "./public/files/"
  types = ["thumbnail", "smallPic", "bigPic"]

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
          title = title.replace /\.(?=[^.]*$)/, "_"+Date.now()+"_copy."
          file.setFieldValue "title", title
        file.setFieldValue "link", title
        copyImages file, true # move = true, only moving
      file.save ->
        req.io.broadcast 'updateCollection', cfg.collectionName


  app.post "/uploadFile", auth, (req,res)->
    #c.l "upload", req, res
    form = new multiparty.Form 
      uploadDir: dir
    form.parse req, (err, fields, files)->
      if err then return console.log 'formparse error', err
      uploadFile = (srcFile, done)->
        title = safeFilename srcFile.originalFilename
        fs.renameSync srcFile.path, dir+title
        file = utils.createModel File, cfg
        file.setFieldValue
          "title": title
          "link": title
          "type": srcFile.headers['content-type']
        if srcFile.headers['content-type'].split("/")[0] is "image"
          createImages file, req, (file)->
            #console.log file,"createimage file"
            file.save ->
              req.io.broadcast "updateCollection", cfg.collectionName
              done()
        else
          file.save ->
            req.io.broadcast "updateCollection", cfg.collectionName
            done()
      async.each files['files[]'], uploadFile, ->
        console.log("uploaded"+files['files[]'].length+" files")
    res.end()


  #create new copy of the file
  app.on cfg.moduleName+":after:post", (req, res, file) ->
    oldFileName = file.getFieldValue "title"
    newFileName = oldFileName.replace /\.(?=[^.]*$)/, "_"+Date.now()+"_child."
    fs.writeFileSync dir+newFileName, fs.readFileSync dir+oldFileName
    file.setFieldValue 'link', newFileName
    file.setFieldValue 'title', newFileName
    copyImages file

  # clean up files after model is deleted
  app.on cfg.moduleName+':after:delete', (req, res, file)->
    fs.unlinkSync "./public/files/"+file.getFieldValue("title")
    for type in types
      fs.unlinkSync "./public/files/"+file.getFieldValue(type)

  copyImages = (file, move)->
    for type in types
      oldLink = file.getFieldValue type
      newLink = file.getFieldValue('title').replace /\.(?=[^.]*$)/, '_'+type+'.'
      if move
        fs.renameSync dir+oldLink, dir+newLink
      else
        fs.writeFileSync dir+newLink, fs.readFileSync(dir+oldLink)
      file.setFieldValue type, newLink

  safeFilename = (name)->
    title = name
      .replace(/\./g, '-')
      .replace(/\-(?=[^-]*$)/, '.')
      .replace(/\ /g, '_')
      .toLowerCase()
    if fs.existsSync(dir+title) is true
      title = title.replace /\.(?=[^.]*$)/, "_"+Date.now()+"_copy."
    return title

  createImages = (file, req, done) ->
    filename = file.getFieldValue "link"
    portrait = false
    thumbTypes = ["thumbnail", "smallPic", "bigPic"]
    image = gm(dir+filename).size (err, size) ->
      if err then return console.error "createWebPic getSize err=", err
      portrait = true if size.width < size.height
      addFile = (type, cb)->
        console.log type
        maxSize = moduleSetting.getFieldValue type
        targetName = filename.replace /\.(?=[^.]*$)/, '_'+type+'.'
        file.setFieldValue type, targetName
        console.log file.getFieldValue "link", filename
        image.quality parseInt(moduleSetting.fields.quality.value)
        if portrait then image.resize null, maxSize
        else image.resize maxSize
        image.write dir+targetName, ->
          cb()

      #for type, i in thumbTypes then addFile type, file, ->
      #  thumbTypes.splice(i, 1)
      #  console.log thumbTypes, i
      #  if thumbTypes.length is 0 then done(); c.l "i am done"
      async.each thumbTypes, addFile, done
