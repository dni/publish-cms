_ = require("underscore")
fs = require "fs-extra"
ejs = require("ejs")
PrintGenerator = require(__dirname + "/PrintGenerator")
Magazine = require("./../model/MagazineSchema")
Article = require("./../../../lib/model/Schema")("articles")
File = require("./../../../lib/model/Schema")("files")
Settings = require("./../../../lib/model/Schema")("settings")
Page = require("./../../../lib/model/Schema")("pages")

module.exports.generate = (magazine) ->

  Settings.findOne(name: "Magazines").execFind (err, file) ->
    print = if file[0].settings.print.value then true else false

    File.find(relation: "magazine:" + magazine._id).execFind (err, files) ->
      magazinefiles = {}
      _.each files, (file) ->
        fs.copy process.cwd() + "/public/files/" + file.name, process.cwd() + "/public/books/" + magazine.name + "/hpub/images/" + file.name
        magazinefiles[file.key] = file.name
        if file.key is 'cover' then fs.copy process.cwd() + "/public/files/" + file.name, process.cwd() + "/public/books/" + magazine.name + "/hpub/cover.png"

      # generage INDEX
      Page.find(magazine: magazine._id).exec (err, pages) ->

        articleIds = []

        _.each pages, (page) ->
          articleIds.push page.article if page.article
        sortedPages = pages.sort (a,b)->
          return 1 if a.number > b.number
          return -1 if a.number < b.number
          return 0

        Article.find(_id: $in: articleIds).execFind (err, articles) ->
          newarticles = {}
          _.each articles, (article) ->
            newarticles[article._id] = article.title

          # generage index for baker navigation
          template = fs.readFileSync("./components/magazine/" + magazine.theme + "/index.html", "utf8")
          fs.writeFileSync "./public/books/" + magazine.name + "/hpub/index.html", ejs.render template,
            magazine: magazine
            pages: sortedPages
            articles: newarticles

          # generate Editorial
          template = fs.readFileSync("./components/magazine/" + magazine.theme + "/Book Index.html", "utf8")
          fs.writeFileSync "./public/books/" + magazine.name + "/hpub/Book Index.html", ejs.render template,
            magazine: magazine
            pages: sortedPages
            articles: newarticles

          if print
            PrintGenerator.generatePage "Book Index.html", magazine
            PrintGenerator.generatePage "index.html", magazine

      # generate Cover
      template = fs.readFileSync("./components/magazine/" + magazine.theme + "/Book Cover.html", "utf8")
      fs.writeFileSync "./public/books/" + magazine.name + "/hpub/Book Cover.html", ejs.render template,
        magazine: magazine
        cover: magazinefiles["cover"]

      #  generate Back
      template = fs.readFileSync("./components/magazine/" + magazine.theme + "/Book Back.html", "utf8")
      fs.writeFileSync "./public/books/" + magazine.name + "/hpub/Book Back.html", ejs.render template,
        magazine: magazine
        back: magazinefiles["back"]

      # generate Impressum
      template = fs.readFileSync("./components/magazine/" + magazine.theme + "/Tail.html", "utf8")
      fs.writeFileSync "./public/books/" + magazine.name + "/hpub/Tail.html", ejs.render template,
        magazine: magazine



      if print
        PrintGenerator.generatePage "Book Cover.html", magazine
        PrintGenerator.generatePage "Book Back.html", magazine
        PrintGenerator.generatePage "Tail.html", magazine


      # generate JSON
      Page.find(magazine: magazine._id).exec (err, pages) ->

        # first pages
        contents = [
          "Book Cover.html"
          "Book Index.html"
        ]

        for i, page of pages
          j = parseInt(i)+1 # pages starts at 1 ;)
          contents.push "Page#{j}.html"

        # last pages
        contents.push "Tail.html"
        contents.push "Book Back.html"

        Settings.findOne(name: "General").execFind (err, res) ->
          if err then throw err
          domain = res[0].settings.domain.value

          fs.writeFileSync "./public/books/" + magazine.name + "/hpub/book.json", JSON.stringify
            hpub: 1
            title: magazine.title
            author: [magazine.author]
            creator: [magazine.author]
            date: new Date()
            cover: "cover.png"
            url: "book://"+domain+"/issue/"+magazine.name
            orientation: "both"
            zoomable: false
            "-baker-background": "#000000"
            "-baker-vertical-bounce": true
            "-baker-media-autoplay": true
            "-baker-background-image-portrait": "gfx/background-portrait.png"
            "-baker-background-image-landscape": "gfx/background-landscape.png"
            "-baker-page-numbers-color": "#000000"
            contents: contents

      # CHAPTERS
      Page.find(magazine: magazine._id).exec (err, pages) ->
        # generate pages
        _.each pages, (page) ->
          return unless page.layout
          template = fs.readFileSync("./components/magazine/" + magazine.theme + "/pages/" + (page.layout).trim() + ".html", "utf8")
          Article.findOne(_id: page.article).exec (err, article) ->
            if err then return
            File.find(relation: "article:" + article._id).execFind (err, files) ->
              articlefiles = {}
              _.each files, (file) ->
                fs.copySync process.cwd() + "/public/files/" + file.name, process.cwd() + "/public/books/" + magazine.name + "/hpub/images/" + file.name
                articlefiles[file.key] = file.name

              filename = "Page" + page.number + ".html"
              fs.writeFileSync "./public/books/" + magazine.name + "/hpub/" + filename, ejs.render template,
                magazine: magazine
                page: page
                article: article
                files: articlefiles

              PrintGenerator.generatePage filename, magazine if print


