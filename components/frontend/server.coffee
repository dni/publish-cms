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
    #filter condition
    if req.query.category
      condition =
        published: true
        "fields.category.value": req.query.category
    else
      condition =
        published: true

    Article.find(condition).sort(date: -1).execFind (err, articles)->
      if err then res.end()
      addFiles = (article, cb)->
        article.files = []
        File.find("fields.relation.value":article._id).execFind (err, files)->
          if err then return
          for file in files
            article.files.push file
          cb()
      async.each articles, addFiles, -> res.send articles
