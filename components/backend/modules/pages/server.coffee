fs = require("fs-extra")
auth = require './../../utilities/auth'

module.exports.setup = (app, config) ->
  Page = require("../../lib/model/Schema")(config.dbTable)
