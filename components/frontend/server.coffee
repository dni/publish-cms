express = require 'express'
Setting = require(process.cwd()+'/components/backend/lib/model/Schema')('settings')
Blocks = require(process.cwd()+'/components/backend/lib/model/Schema')('staticblocks')
File = require(process.cwd()+'/components/backend/lib/model/Schema')('files')
Article = require(process.cwd()+'/components/backend/lib/model/Schema')('articles')
async = require 'async'

module.exports.setup = (app)->

  app.get '/blocks', (req,res)->
    Blocks.find('fields.title.value':$in: req.query.blocks).exec (err, data)->
      res.send data

  # articles
  app.get '/publicarticles', (req,res)->
    condition =
      published: true

    #filter condition
    if req.query.category
      _.extend {}, condition,
        "fields.category.value": req.query.category

    Article.find(condition).sort(date: -1).execFind (err, articles)->
      addFiles = (article, cb)->
        filearray = []
        File.find("fields.relation.value":article._id.toString()).exec (err, files)->
          for file in files
            fieldrelation = file.fields.fieldrelation.value
            if fieldrelation
              article.fields[fieldrelation].value = file
            else
              filearray.push file
          article.fields.files = filearray
          cb()
      async.each articles, addFiles, -> res.send articles
