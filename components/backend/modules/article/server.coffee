auth = require "../../utilities/auth"
module.exports.setup = (app, config)->
  Article = require('./../../lib/model/Schema')(config.dbTable)
