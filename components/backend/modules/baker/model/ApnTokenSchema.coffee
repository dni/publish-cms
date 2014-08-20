mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = mongoose.model 'ApnToken', new Schema
  app_id: String
  user_id: String
  apns_token: String