async = require "async"
auth = require './../../utilities/auth'
module.exports.setup = (app, config)->

  app.get "/clearCache", auth, (req, res) ->
    app.log "cleared the cache", undefined, app.user.fields.title.value

