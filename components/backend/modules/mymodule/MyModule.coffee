define [
    'cs!Publish'
    'text!./configuration.json'
    'i18n!modules/mymodule/nls/language.js'
    'cs!./model/MyCollection'
    'cs!./controller/MyController'
], ( Publish, ConfigJSON, i18n, MyCollection, MyController ) ->

  new Publish.Module
    Config: JSON.parse ConfigJSON
    Controller: MyController
    Collection: MyCollection
    i18n: i18n