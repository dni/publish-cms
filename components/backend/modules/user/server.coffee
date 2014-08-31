Setting = require('./../../lib/model/Schema')("settings")
express = require 'express'
auth = require "../../utilities/auth"
utils = require "../../utilities/utils"
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

  # create default admin user if no user exists
  User.count {}, (err, count)->
    if count == 0
      admin = utils.createModel User, config

      admin.setFieldValue 
        'email': "admin@publish.org"
        'username': "admin"
        'password': "password"
        'title': "administrator"

      admin.save()
      console.log "admin user was created"
