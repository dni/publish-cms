mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = mongoose.model 'Receipts', new Schema
  transaction_id: String
  app_id: String
  user_id: String
  product_id: String
  type: String
  base64_receipt: String
