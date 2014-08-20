Setting = require("./../../lib/model/Schema")('settings')
Magazine = require("./../../lib/model/Schema")('magazines')
auth = require './../../utilities/auth'
http = require("http")
_ = require("underscore")
ApnToken = require(__dirname + "/model/ApnTokenSchema")
Issue = require(__dirname + "/model/IssueSchema")
PurchasedIssue = require(__dirname + "/model/PurchasedIssueSchema")
Receipt = require(__dirname + "/model/ReceiptSchema")
BakerGenerator = require(__dirname + "/generators/BakerGenerator")

Number::pad = (digits, signed) ->
  s = Math.abs(@).toString()
  s = "0" + s while s.length < digits
  (if @ < 0 then "-" else (if signed then "+" else "")) + s


Date::format = (fmt) ->
  parts = fmt.split "%%"
  for own char, callback of Date.formats
    r = new RegExp("%#{char}", "g")
    parts = (part.replace(r, => callback.apply(this)) for part in parts)
  parts.join "%"

Date::getDayOfYear = -> Math.ceil((@getTime() - new Date(@getFullYear(), 0, 1).getTime()) / 24 / 60 / 60 / 1000)

Date::getWeekOfYear = (start = 0) ->
  Math.floor((@getDayOfYear() - (start + 7 - new Date(@getFullYear(), 0, 1).getDay()) % 7) / 7) + 1

Date.formats =
  "c": -> @toLocaleString()
  "d": -> @getDate().toString()
  "F": -> "#{@getFullYear()}-#{@getMonth() + 1}-#{@getDate()}"
  "H": -> @getHours().pad(2)
  "I": -> "#{(@getHours() % 12) || 12}"
  "j": -> @getDayOfYear()
  "L": -> @getMilliseconds().pad(3)
  "m": -> (@getMonth() + 1).pad(2)
  "M": -> @getMinutes().pad(2)
  "N": -> @getMilliseconds().pad(3)
  "p": -> if @getHours() < 12 then "AM" else "PM"
  "P": -> if @getHours() < 12 then "am" else "pm"
  "S": -> @getSeconds().pad(2)
  "s": -> Math.floor(@getTime() / 1000)
  "U": -> @getWeekOfYear()
  "w": -> @getDay()
  "W": -> @getWeekOfYear(1)
  "y": -> @getFullYear() % 100
  "Y": -> @getFullYear()
  "x": -> @toLocaleDateString()
  "X": -> @toLocaleTimeString()
  "z": -> Math.floor((z = -@getTimezoneOffset()) / 60).pad(2, true) + (Math.abs(z) % 60).pad(2)
  "Z": -> /\(([^\)]*)\)$/.exec(@toString())[1]

module.exports.setup = (app) ->

  app.get "/downloadApp", BakerGenerator.download

  # BAKER SERVER API
  app.post "/purchase_confirmation", (req, res) ->
    receipt = new Receipt()
    receipt.app_id = req.body.app_id
    receipt.user_id = req.body.user_id
    receipt.purchase_type = req.body.purchase_type
    receipt.base64_receipt = req.body.base64_receipt
    options =
      host: "sandbox.itunes.apple.com"
      port: "80"
      path: "/verifyReceipt"
      method: "POST"

    post = http.request options, (res) ->
      console.log "verify user res: ", res
      console.log "Invalid receipt for $product_id : status " + data.status  if not res.data or (res.data.status isnt 0 and data.status isnt 21006)

    post.write(
      receipt_data: receipt.base64_receipt
      password: "dnilabs"
    ).end()
    console.log "Saving " + receipt.purchase_type + " " + "" + " app:" + receipt.app_id + " user:" + receipt.user_id + " in the receipt database"
    res.end()


  app.post "/post_apns_token", (req, res) ->
    token = new ApnToken()
    token.app_id = req.body.app_id
    token.apns_token = req.body.apns_token
    token.user_id = req.body.user_id
    console.log "/post_apns_token: " + token.apns_token + " app:" + token.app_id + " user:" + token.user_id + " in the database"
    token.save -> res.end()

  app.get "/shelf", (req, res) ->
    Magazine.find(published: 1).execFind (arr, magazines) ->
      json = []
      Setting.findOne(name: "Baker").execFind (arr, bakersetting) ->
        bakersetting = bakersetting[0]
        Setting.findOne(name: "General").execFind (arr, setting) ->
          setting = setting[0]
          _.each magazines, (magazine) ->
            date = magazine.date.format "%Y-%m-%d %H:%M:%S"
            item =
              name: magazine.name
              title: magazine.title
              info: magazine.info
              date: date
              cover: "http://" + setting.settings.domain.value + "/public/books/" +magazine.name+ "/hpub/cover.png"
              url: "http://" + setting.settings.domain.value + "/issue/" +magazine.name+".hpub"
              product_id: magazine.product_id

            delete item.product_id if bakersetting.settings.apptype.value isnt "paid"

            json.push item

          res.send JSON.stringify(json)

# need 1887-11-24 09:00:00
# have 2014-06-04T14:54:50.260Z

  # endpoint for downloading hpub file (zip)
  app.get "/issue/:title", (req, res) ->

    magazine = req.params.title or req.body.name

    # only free issues so far
    spawn = require("child_process").spawn
    zip = spawn("zip", ["-r", "-", ".", "*"], cwd: "./public/books/" + magazine.replace('.hpub', '/hpub'))
    res.contentType "hpub"
    zip.stdout.on "data", (data) -> res.write data
    zip.stderr.on 'data', (data) -> console.log 'zip stderr: '+data

    zip.on "exit", (code) ->
      if code isnt 0
        res.statusCode = 500
        console.log "zip process exited with code " + code
        res.end()
      else
        console.log "zip done"
        res.end()
