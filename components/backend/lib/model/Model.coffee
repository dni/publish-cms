define [
  'cs!App'
  'backbone'
  'underscore'
], (App, Backbone, _) ->
  class Model extends Backbone.Model
    idAttribute: "_id"
    defaults:
      fields: {}

    setValue: (fieldname, val)->
      fields = @get "fields"
      if _.isObject fieldname
        for key, value of fieldname
          fields[key].value = value
      else
        fields[fieldname].value = val
      @set "fields", fields

    getValue: (fieldname)->
      fields = @get "fields"
      return fields[fieldname]?.value

    getCollection: (fieldname, collectionField)->
      fields = @get "fields"
      field = fields[fieldname]
      if field
        collectionName = fields[fieldname].collection
        coll = App[collectionName].findWhere "_id":fields[fieldname].value
        coll.getValue collectionField

    togglePublish: ->
      @.set "published", not @.get "published"

