mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = mongoose.model 'PurchasedIssue', new Schema
  app_id: String
  user_id: String
  product_id: String
