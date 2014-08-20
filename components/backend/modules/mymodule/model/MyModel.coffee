define [
  'cs!Publish'
  'text!../configuration.json'
], (Publish, Config) ->
  class MyModel extends Publish.Model
    urlRoot: Config.urlRoot
    defaults:
      "_id": undefined
      "title": "Neuer Artikel"
      "desc": "Hello World!"
      "teaser": "Hello World!"
      "files": []
      "author": "dnilabs"
      "published": false
      "category": ""
      "tags": ""