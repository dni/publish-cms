define [
  "backbone"
  "underscore"
], (Backbone, _) ->
  class Collection extends Backbone.Collection
    findSetting:(moduleName)->
      arr = _.filter @.models, (model)->
        return model.attributes.fields?.title?.value is moduleName
      return arr[0]
