Setting = require('./../../lib/model/Schema')("settings")
express = require 'express'
auth = require "../../utilities/auth"
passport = require 'passport'

module.exports.setup = (app, config)->
  User = require('../../lib/model/Schema')(config.dbTable)

  # login
  app.get '/login', (req, res)->
    res.sendfile process.cwd()+'/components/backend/login.html'

  app.post '/login', passport.authenticate('local', failureRedirect: '/login'), (req, res)->
    res.redirect '/admin'

  app.get '/logout', (req, res)->
    req.logout()
    res.redirect '/login'

  app.get "/user", (req, res)->
    res.send app.user

  #admin route
  app.get '/admin', auth, (req, res)->
    Setting.find name:'General', (e, a)->
      # if setting doesnt exists start in development mode
      if a.length is 0 || a[0].settings.backend_development.value
        console.log "Starting backend in development mode"
        app.use '/components', express.static process.cwd()+'/components'
        res.sendfile process.cwd()+'/components/backend/index.html'
      else
        console.log "Starting backend in production mode"
        app.use '/components', express.static process.cwd()+'/cache/build'
        res.sendfile process.cwd()+'/cache/build/backend/index.html'
  # create default admin user if no user exists
  User.count {}, (err, count)->
    if count == 0
      admin = new User
      admin.name = config.modelName
      admin.fields =
        email:
          type:"text"
          value:"admin@publish.org"
        username:
          type:"text"
          value:"admin"
        password:
          type:"text"
          value:"password"
        title:
          type:"text"
          value:"administrator"

      admin.save()
      console.log "admin user was created"
