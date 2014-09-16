ejs = require "ejs"
fs = require "fs-extra"
Settings = require("./../../../lib/model/Schema")("settings")
createAppAssests = require './CreateAppAssets'
i18n = require './../nls/baker.json'

module.exports = (setting, cb)->
  StaticBlocks =   require('./../../../lib/model/Schema')('staticblocks')
  Settings.findOne({"fields.title.value": "PublishModule"}).exec (error, generalsetting) ->

    dirname = process.cwd()+"/cache/publish-baker";
    settingFields = setting.fields
    domain = generalsetting.fields.domain.value
    # Constants
    template = fs.readFileSync(__dirname+"/templates/Constants.h", "utf-8")
    fs.writeFileSync dirname+"/BakerShelf/Constants.h", ejs.render template,
      settings: settingFields
      domain: domain

    # Localizeable Strings
    template = fs.readFileSync(__dirname+"/templates/Localizable.strings", "utf-8")
    for key, language of i18n
      if !fs.existsSync dirname+"/Baker/"+key+".lproj" then fs.mkdirSync dirname+"/Baker/"+key+".lproj"
      fs.writeFileSync dirname+"/Baker/"+key+".lproj/Localizable.strings", ejs.render template,
        settings: settingFields
        localisation: language
        domain: domain

    # Ui constants
    template = fs.readFileSync(__dirname+"/templates/UIConstants.h", "utf-8")
    fs.writeFileSync dirname+"/BakerShelf/UIConstants.h", ejs.render template,
      settings: settingFields

    # Baker-Info.plist
    template = fs.readFileSync(__dirname+"/templates/Baker-Info.plist", "utf-8")
    fs.writeFileSync dirname+"/Baker/Baker-Info.plist", ejs.render template,
      settings: settingFields
      domain: domain

    #info menu
    StaticBlocks.findOne("fields.title.value": "info").exec (err, block) ->
      unless block? then return console.log("No StaticBlocks 'info'")

      template = fs.readFileSync(__dirname+"/templates/info.html", "utf-8")
      fs.writeFileSync dirname+"/BakerShelf/info/info.html", ejs.render template,
        block: block.data

    # modified project file
    template = fs.readFileSync(__dirname+"/templates/project.pbxproj", "utf-8")
    fs.writeFileSync dirname+"/Baker.xcodeproj/project.pbxproj", template

    cb()
