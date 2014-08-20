express = require 'express'
Article = require process.cwd()+'/components/backend/modules/article/model/ArticleSchema'
File = require process.cwd()+'/components/backend/modules/files/model/FileSchema'
Setting = require process.cwd()+'/components/backend/modules/settings/model/SettingSchema'
Blocks = require process.cwd()+'/components/backend/modules/static/model/StaticBlockSchema'
async = require 'async'

module.exports.setup = (app)->
  app.get '/', (req,res)->
    Setting.find name:'General', (e, a)->
      if a.length is 0 || a[0].settings.frontend_development.value
        console.log "Starting frontend in development mode"
        app.use '/', express.static __dirname
        res.sendfile __dirname+'/index.html'
      else
        console.log "Starting frontend in production mode"
        app.use '/', express.static process.cwd()+'/cache/build/frontend'
        res.sendfile process.cwd()+'/cache/build/frontend/index.html'

  app.get '/blocks', (req,res)->
    Blocks.find('key':$in: req.query.blocks).execFind (err, data)->res.send data

  # articles
  app.get '/publicarticles', (req,res)->
    #filter condition
    if req.query.category
      condition =
        published: true
        category: req.query.category
    else
      condition =
        published: true

    Article.find(condition).sort(date: -1).execFind (err, articles)->
      if err then res.end()
      addFiles = (article, cb)->
        article.files = []
        File.find(relation:'article:'+article._id).execFind (err, files)->
          if err then return
          for file in files
            article.files.push file
          cb()

      async.each articles, addFiles, -> res.send articles


