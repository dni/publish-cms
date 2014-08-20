mongoose = require 'mongoose/'
Config = require '../configuration.json'
Schema = mongoose.Schema

module.exports = mongoose.model Config.dbTable, new Schema
  user: String
  title: String
  date: Date
  published: Boolean
  category: String
  tags: String
  files: Object