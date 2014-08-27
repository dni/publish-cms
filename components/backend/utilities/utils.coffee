module.exports =
  createModel: (Model, config)->
    model = new Model
    model.fields = config.model
    model.fieldorder = Object.keys config.model
    model.name = config.modelName
    return model

