define [
  'backbone'
  'underscore'
], (Backbone, _) ->
  class Model extends Backbone.Model
    idAttribute: "_id"
    defaults:
      fields: {}

    setValue: (fieldname, val)->
      fields = @get "fields"
      if _.isObject fieldname
        for key, value of fieldname
          fields[key] = value
      else
        fields[fieldname] = val
      @set "fields", fields

    getValue: (fieldname)->
      fields = @get "fields"
      return fields[fieldname].value

    togglePublish: ->
      @.set "published", not @.get "published"

