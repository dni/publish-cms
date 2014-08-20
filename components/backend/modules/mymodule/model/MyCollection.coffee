define [
  "cs!Publish"
  "cs!./MyModel"
  "text!../configuration.json"
], (Publish, Model, Config) ->
  class MyCollection extends Publish.Collection
    model: Model
    url: Config.url