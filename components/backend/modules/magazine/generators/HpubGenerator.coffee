_ = require("underscore")
fs = require "fs-extra"
ejs = require("ejs")
PrintGenerator = require(__dirname + "/PrintGenerator")
Magazine = require("./../../../lib/model/Schema")("magazines")
Article = require("./../../../lib/model/Schema")("articles")
File = require("./../../../lib/model/Schema")("files")
Settings = require("./../../../lib/model/Schema")("settings")
Page = require("./../../../lib/model/Schema")("pages")

module.exports.generate = (magazine) ->
  id = magazine._id.toString()
  theme = magazine.fields.theme.value || "default"
  title = magazine.fields.name.value || "default-title"




  Settings.findOne("fields.title.value": "MagazineModule").exec (err, settings) ->
    print = settings.fields.print.value

    File.find("fields.relation.value": id).execFind (err, files) ->
      return console.log err if err 
      _.each files, (file) ->
        fileName = file.fields.title.value
        if file.fields.fieldrelation.value is "cover"
          fs.copy process.cwd() + "/public/files/" + fileName, process.cwd() + "/public/books/" + title + "/hpub/images/cover.png"
        else if file.fields.fieldrelation.value is "back"
          fs.copy process.cwd() + "/public/files/" + fileName, process.cwd() + "/public/books/" + title + "/hpub/images/back.png"
        else
          fs.copy process.cwd() + "/public/files/" + fileName, process.cwd() + "/public/books/" + title + "/hpub/images/" + file.name

      # generage INDEX
      Page.find("fields.relation.value": id).exec (err, pages) ->

        articleIds = []

        _.each pages, (page) ->
          pageArticle = page.fields.article.value 
          articleIds.push pageArticle if pageArticle
        sortedPages = pages.sort (a,b)->
          return 1 if a.number > b.number
          return -1 if a.number < b.number
          return 0


        Article.find(_id: $in: articleIds).execFind (err, articles) ->
          newarticles = {}
          _.each articles, (article) ->
            newarticles[article._id] = {}
            newarticles[article._id].title = article.fields.title.value
            File.find("fields.relation.value": article._id.toString()).execFind (err, files) ->
              _.each files, (file) ->
                if file.fields.fieldrelation.value is "teaserimage"
                  console.log "found teaserImage"
                  fs.copySync process.cwd() + "/public/files/" + file.fields.title.value, process.cwd() + "/public/books/" + title + "/hpub/images/" + file.fields.title.value
                  newarticles[article._id].teaserimage = file.fields.title.value || null

              # generage index for baker navigation
              template = fs.readFileSync("./components/magazine/" + theme + "/index.html", "utf8")
              fs.writeFileSync "./public/books/" + title + "/hpub/index.html", ejs.render template,
                magazine: magazine
                pages: sortedPages
                articles: newarticles

              # generate Editorial
              template = fs.readFileSync("./components/magazine/" + theme + "/Book Index.html", "utf8")
              fs.writeFileSync "./public/books/" + title + "/hpub/Book Index.html", ejs.render template,
                magazine: magazine
                pages: sortedPages
                articles: newarticles

              if print
                PrintGenerator.generatePage "Book Index.html", magazine
                PrintGenerator.generatePage "index.html", magazine

      # generate Cover
      template = fs.readFileSync("./components/magazine/" + theme + "/Book Cover.html", "utf8")
      fs.writeFileSync "./public/books/" + title + "/hpub/Book Cover.html", ejs.render template,
        magazine: magazine
        cover: "cover.png"

      #  generate Back
      template = fs.readFileSync("./components/magazine/" + theme + "/Book Back.html", "utf8")
      fs.writeFileSync "./public/books/" + title + "/hpub/Book Back.html", ejs.render template,
        magazine: magazine
        back: "back.png"

      # generate Impressum
      template = fs.readFileSync("./components/magazine/" + theme + "/Tail.html", "utf8")
      fs.writeFileSync "./public/books/" + title + "/hpub/Tail.html", ejs.render template,
        magazine: magazine

      if print
        PrintGenerator.generatePage "Book Cover.html", magazine
        PrintGenerator.generatePage "Book Back.html", magazine
        PrintGenerator.generatePage "Tail.html", magazine


      # generate JSON
      Page.find("fields.relation.value": id).exec (err, pages) ->

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

        Settings.findOne("fields.title.value": "PublishModule").exec (err, setting) ->
          if err then return console.log err
          domain = setting.fields.domain.value

          fs.writeFileSync "./public/books/" + title + "/hpub/book.json", JSON.stringify
            hpub: 1
            title: magazine.title
            author: [magazine.author]
            creator: [magazine.author]
            date: new Date()
            cover: "cover.png"
            url: "book://"+domain+"/issue/"+title
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

        # generate pages
        _.each pages, (page) ->
          pagelayout = page.fields.layout.value || "default"
          theme = page.fields.theme?.value || "default"
          return unless pagelayout
          template = fs.readFileSync("./components/magazine/" + theme + "/pages/" + (pagelayout).trim() + ".html", "utf8")
          Article.findOne(_id: page.fields.article.value).exec (err, article) ->
            if err then return console.log err
            articleId = article._id.toString()
            File.find("fields.relation.value": articleId).execFind (err, files) ->
              articlefiles = []
              _.each files, (file) ->
                if file.fields.fieldrelation.value isnt "teaserimage"
                  fs.copySync process.cwd() + "/public/files/" + file.fields.title.value, process.cwd() + "/public/books/" + title + "/hpub/images/" + file.fields.title.value
                  articlefiles.push file.fields.title.value

              filename = "Page" + page.fields.number.value + ".html"
              fs.writeFileSync "./public/books/" + title + "/hpub/" + filename, ejs.render template,
                magazine: magazine
                page: page
                article: article
                files: articlefiles

              PrintGenerator.generatePage filename, magazine if print