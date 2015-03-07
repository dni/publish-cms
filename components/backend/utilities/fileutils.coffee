async = require "async"
csv = require "csv"
gm = require 'gm'
fs = require "fs-extra"
dir = "./public/files/"
types = ["thumbnail", "smallPic", "bigPic"]


module.exports = (app, setting)->

  safeFilename: (name)->
    title = name
      .replace(/\./g, '-')
      .replace(/\-(?=[^-]*$)/, '.')
      .replace(/\ /g, '_')
    if fs.existsSync(dir+title)
      title = title.replace /\.(?=[^.]*$)/, "_"+Date.now()+"_copy."
    return title

  deleteFile: (file, done)->
    fs.unlinkSync dir+file.getFieldValue("title")
    if file.getFieldValue("type").split("/")[0] is "image"
      fs.unlinkSync dir+file.getFieldValue(type) for type in types

  createImages: (file, done)->
    filename = file.getFieldValue "title"
    quality = parseInt setting.getFieldValue('quality')
    image = gm(dir+filename).size (err, size) ->
      portrait = if size.width < size.height then true else false
      async.each types, (type, cb)->
          maxSize = setting.getFieldValue type
          # replace last dot in filename
          targetName = filename.replace /\.(?=[^.]*$)/, '_'+type+'.'
          file.setFieldValue type, targetName
          image.quality quality
          if portrait then image.resize null, maxSize
          else image.resize maxSize
          image.write dir+targetName, cb
      , ->
        file.save done

  copyImage: (file, done)->

  updateFile: (file, done)->
    link = file.getFieldValue "link"
    if title != link
      safe = @safeFilename link
      file.setFieldValue title:safe
      @moveFile file, done

  moveFile: (file, done)->
    oldLink = file.getFieldValue type
    newLink = file.getFieldValue('title')
    fs.renameSync dir+oldLink, dir+newLink
    file.setFieldValue type, newLink
    done()

  cropImage: (file, done)->
    gmImg = gm(dir+file.getFieldValue("title"))
    crop = file.get "crop"
    gmImg.size (err, size)->
      return if err
      ratio = size.width / crop.origSize.w
      gmImg.crop(crop.w*ratio, crop.h*ratio, crop.x*ratio, crop.y*ratio)
      gmImg.write dir+title, done


  importCsv: (file, done)->
    importFailed = "import failed "
    csvLink = dir+file.getFieldValue "link"
    input = fs.readFileSync(csvLink).toString()
    collectionName = file.getFieldValue("link").split(".").shift().split('_').shift()
    config = app.collections[collectionName]
    return app.log importFailed+"collection: "+collectionName+" doesnt exist.", "error" unless config?
    csv.parse input, {delimiter: ";"}, (err, data)->
      fields = data.shift()
      async.eachSeries data, (row, cb)->
        model = app.createModel config.moduleName
        async.eachSeries fields, (field, cb2)->
          j = fields.indexOf(field)
          modelField = config.model[field]
          return app.log importFailed+field+" doesnt exist in config.", "error" unless modelField?
          if modelField.collection?
            Collection = require("../lib/model/Schema")(modelField.collection)
            Collection.findOne("fields.title.value": row[j]).exec (err, submodel)->
              return app.log importFailed+field+" with title: " + row[j] + " doesnt exist.", "warn" unless submodel?
              value = submodel.get "id"
              model.setFieldValue(field, value)
              cb2()
          else
            value = row[j]
            model.setFieldValue(field, value)
            cb2()
        , ->
          model.save cb
      , ->
        app.log "import success, created " + data.length + " rows from " + collectionName + ".", "new"
        app.io.broadcast "updateCollection", collectionName
        done()

