mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = mongoose.model 'Issue', new Schema
  name: String
  app_id: String
  title: String
  info: String
  date: Date
  cover: String
  product_id: String
