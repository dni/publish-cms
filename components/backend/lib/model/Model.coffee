define [
  'backbone'
], (Backbone) ->
  class Model extends Backbone.Model
    idAttribute: "_id"
    defaults:
      fields: {}

    setValue: (fieldname, val)->
      fields = @get "fields"
      field = fields[fieldname]
      field.value = val
      @set "fields", fields

    getValue: (fieldname)->
      fields = @get "fields"
      return fields[fieldname].value

    togglePublish: ->
      @.set "published", not @.get "published"

