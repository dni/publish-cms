define [], ->
  settings:(models)->
    for model in models
      for key, setting of model.attributes.settings
        c.l model.attributes.title, key, setting
