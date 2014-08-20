ejs = require "ejs"
fs = require "fs-extra"
Settings = require("./../../../lib/model/Schema")("settings")
createAppAssests = require './CreateAppAssets'
i18n = require './../nls/baker.json'

module.exports = (setting, cb)->
  StaticBlocks =   require('./../../../lib/model/Schema')('staticblocks')
  Settings.findOne(name: "General").exec (error, generalsetting) ->

    dirname = process.cwd()+"/cache/publish-baker";

    # Constants
    template = fs.readFileSync(__dirname+"/templates/Constants.h", "utf-8")
    fs.writeFileSync dirname+"/BakerShelf/Constants.h", ejs.render template,
      settings: setting.settings
      domain: generalsetting.settings.domain.value

    # Localizeable Strings
    template = fs.readFileSync(__dirname+"/templates/Localizable.strings", "utf-8")
    for key, language of i18n
      if !fs.existsSync dirname+"/Baker/"+key+".lproj" then fs.mkdirSync dirname+"/Baker/"+key+".lproj"
      fs.writeFileSync dirname+"/Baker/"+key+".lproj/Localizable.strings", ejs.render template,
        settings: setting.settings
        localisation: language
        domain: generalsetting.settings.domain.value

    # Ui constants
    template = fs.readFileSync(__dirname+"/templates/UIConstants.h", "utf-8")
    fs.writeFileSync dirname+"/BakerShelf/UIConstants.h", ejs.render template,
      settings: setting.settings

    # Baker-Info.plist
    template = fs.readFileSync(__dirname+"/templates/Baker-Info.plist", "utf-8")
    fs.writeFileSync dirname+"/Baker/Baker-Info.plist", ejs.render template,
      settings: setting.settings
      domain: generalsetting.settings.domain.value

    #info menu
    StaticBlocks.findOne(attributes: key: "info").exec (err, block) ->
      template = fs.readFileSync(__dirname+"/templates/info.html", "utf-8")
      fs.writeFileSync dirname+"/BakerShelf/info/info.html", ejs.render template,
        block: block.data

    # modified project file
    template = fs.readFileSync(__dirname+"/templates/project.pbxproj", "utf-8")
    fs.writeFileSync dirname+"/Baker.xcodeproj/project.pbxproj", template

    cb()
