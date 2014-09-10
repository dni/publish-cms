define [
  "backbone"
  "underscore"
  "cs!./Model"
], (Backbone, _, Model) ->
  class Collection extends Backbone.Collection
    findSetting:(moduleName)->
      arr = _.filter @.models, (model)->
        return model.attributes.fields?.title?.value is moduleName
      return arr[0]
