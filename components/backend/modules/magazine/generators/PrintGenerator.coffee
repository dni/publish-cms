fs = require("fs")
scissors = require("scissors")
_ = require("underscore")
path = require("path")
mime = require("mime")
phantom = require("phantom")
port = 40000

module.exports.download = (req, res) ->
  pages = []
  fs.unlink "./public/books/" + req.params.name + "/pdf/Print.pdf", ->
    fs.readdir "./public/books/" + req.params.name + "/pdf/", (err, files) ->
      return if err
      _.each files, (file) ->
        pages.push scissors("./public/books/" + req.params.name + "/pdf/" + file) if file.match(/.pdf/g)
      pdfStream = scissors.join.apply(null, pages).pdfStream()
      pdfStream.pipe res
      pdfStream.on "end", -> res.end()

module.exports.generatePage = (file, magazine) ->
  phantom.create port: port++, (ph) ->
    ph.createPage (page) ->
      page.open "./public/books/" + magazine.name + "/hpub/" + file, (status) ->
        ph.exit() if status isnt "success"
        page.evaluate (-> document), (result) ->
          page.set "paperSize",
            format: magazine.papersize
            orientation: magazine.orientation
            margin: "0"
          page.render "./public/books/" + magazine.name + "/pdf/" + file.split(".").shift() + ".pdf"
