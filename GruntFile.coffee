config = require "./configuration.json"
backend_modules = require("./components/backend/configuration.json").backend_modules

mongoose = require "mongoose"
db = mongoose.connect 'mongodb://localhost/'+config.dbname
Magazine = require __dirname+"/components/backend/modules/magazine/model/MagazineSchema"
HpubGenerator = require __dirname + "/components/backend/modules/magazine/generators/HpubGenerator"
fs = require "fs-extra"

module.exports = (grunt)->
  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    watch:
      scripts:
        files: ['components/**/*.coffee']
        tasks: ['test']
        options:
          spawn: false
      json:
        files:  ['components/**/*.json', '!staticblocks.json']
        tasks: ['jsonlint']
        options:
          spawn: false
      magazine:
        files: ['components/magazine/**/*']
        tasks: ['generateMagazine']
        options:
          spawn: false
      server:
        files: ['server.coffee']
        tasks: ['restart']
        options:
          spawn: false

    coffeelint:
      all:
        options:
          'max_line_length':
            level: 'ignore'
        files:
          src: ['components/backend/**/*.coffee', 'components/frontend/**/*.coffee']

    jsonlint:
      all:
        src:  ['components/**/*.json']

    jasmine:
      backend:
        src: '*.js'
        options:
          specs: 'components/backend/modules/**/spec/*Spec.js'
          helpers: 'components/backend/modules/**/spec/*Helper.js'
          # host : 'http://localhost:1666/admin/'
          template: require 'grunt-template-jasmine-requirejs'
          templateOptions:
            requireConfigFile: 'components/backend/config.js'

    clean:
      everything: src: [
        'baker-master'
        'bower_components'
        'lib'
        'node_modules'
        'cache'
        'components/backend/vendor'
        'components/magazine/vendor'
        'components/frontend/vendor'
        'public/files'
        'public/books'
      ]
      reinstall: src: [
        'baker-master'
        'bower_components'
        'lib'
        'cache'
        'components/backend/vendor'
        'components/magazine/vendor'
        'components/frontend/vendor'
        'public/files'
        'public/books'
      ]
      baker: src: [ 'baker-master/books' ]
      lib: src: [ 'lib' ]
      build: src: [ 'cache/build' ]
      buildFrontend: src: [ 'cache/build/frontend' ]
      buildBackend: src: [ 'cache/build/backend' ]
      vendorFrontend: src: [ 'components/backend/vendor' ]
      vendorBackend: src: [ 'components/frontend/vendor' ]
      vendorMagazine: src: [ 'components/magazine/vendor' ]

    mkdir:
      all:
        options:
          create: [
            'cache'
            'public/books'
            'public/files'
            'baker-master/books'
          ]

    bower:
      install:
        option:
          targetDir: 'bower_components'

    gitclone:
      baker:
        options:
          repository: 'https://github.com/bakerframework/baker.git'
          directory: 'baker-master'


    bowercopy:
      libsBackend:
        options:
          destPrefix: "components/backend/vendor"
        files:
          "jquery.js": "jquery/dist/jquery.js"
          "io.js": "socket.io-client/dist/socket.io.js"
          "require.js": "requirejs/require.js"
          "jquery.ui.js": "jquery-ui/jquery-ui.js"
          "jquery.form.js": "jquery-form/jquery.form.js"
          "underscore.js": "underscore/underscore.js"
          "wreqr.js": "backbone.wreqr/lib/backbone.wreqr.js"
          "babysitter.js": "backbone.babysitter/lib/backbone.babysitter.js"
          "backbone.js": "backbone/backbone.js"
          "marionette.js": "marionette/lib/backbone.marionette.js"
          "text.js": 'requirejs-text/text.js'
          "tpl.js": 'requirejs-tpl/tpl.js'
          "cs.js": 'require-cs/cs.js'
          "i18n.js": 'requirejs-i18n/i18n.js'
          "coffee-script.js": 'coffee-script/extras/coffee-script.js'
          "notify.js": "notifyjs/dist/notify-combined.min.js"
          "bootstrap.js": "bootstrap/dist/js/bootstrap.js"
          "jquery.minicolors.js": "jquery-minicolors/jquery.minicolors.js"
          "jquery.jcrop.js": "jcrop/js/jquery.Jcrop.js"
          "tinymce": "tinymce-builded/js/tinymce"
          "less.js": "require-less/less.js"
          "less-builder.js": "require-less/less-builder.js"
          "css.js": "require-css/css.js"
          "css-builder.js": "require-css/css-builder.js"
          "normalize.js": "require-css/normalize.js"
          "lessc.js": "require-less/lessc.js"
          # style
          "style": "bootstrap/less"
          "style/boostrap.css": "bootstrap/dist/css/bootstrap.css"
          "style/.": "jcrop/css/*"
          "style/jquery.minicolors.css": "jquery-minicolors/jquery.minicolors.css"
          "style/jquery.minicolors.png": "jquery-minicolors/jquery.minicolors.png"



      libsFrontend:
        options:
          destPrefix: "components/frontend/vendor"
        files:
          "jquery.js": "jquery/dist/jquery.js"
          "require.js": "requirejs/require.js"
          "backbone.js": "backbone/backbone.js"
          "marionette.js": "marionette/lib/backbone.marionette.js"
          "babysitter.js": "backbone.babysitter/lib/backbone.babysitter.js"
          "wreqr.js": "backbone.wreqr/lib/backbone.wreqr.js"
          "coffee-script.js": 'coffee-script/extras/coffee-script.js'
          "underscore.js": 'underscore/underscore.js'
          "text.js": 'requirejs-text/text.js'
          "tpl.js": 'requirejs-tpl/tpl.js'
          "cs.js": 'require-cs/cs.js'
          "i18n.js": 'requirejs-i18n/i18n.js'
          # Folders
          "css": 'require-css'
          "fancybox": "fancybox/source"
          "bootstrap": "bootstrap"
          "require-less": 'require-less'

      libsMagazine:
        options:
          destPrefix: "components/magazine/js/vendor"
        files:
          "jquery.min.js": "jquery/dist/jquery.min.js"

    copy:
      tinymce:
        cwd: 'components/backend/modules/publish/nls/langs-tinymce'
        src: '*'
        dest: 'components/backend/vendor/tinymce/langs'
        expand: true

    requirejs:
      backend:
        options:
          appDir: 'components/backend'
          baseUrl: 'vendor'
          fileExclusionRegExp: /^(server|spec)/
          dir: "cache/build/backend"
          optimizeAllPluginResources: true,
          findNestedDependencies: true,
          stubModules: ['less', 'css', 'cs', 'coffee-script'],
          modules: [{
            name: 'config'
            include: backend_modules
            exclude: ['coffee-script', 'css', 'less']
          }]
          # out : './components/backend/build.min.js'
          optimize : 'uglify2',
          shim:
            'jquery.tinymce':['jquery', 'tinymce']
          paths:
            main: '../main'
            config: '../config'
            lib: '../lib'
            utilities: '../utilities'
            modules: '../modules'
            App: "../utilities/App"
            Publish: "../lib/Publish"
            Router: '../utilities/Router'
            Utils: '../utilities/Utilities'
            tinymce: 'tinymce/tinymce',
            plugins: 'tinymce/tinymce/plugins',
            'jquery.tinymce': 'tinymce/jquery.tinymce.min',

  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'

  grunt.loadNpmTasks 'grunt-jsonlint'

  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-coffeelint'

  grunt.loadNpmTasks 'grunt-mkdir'
  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-git'
  grunt.loadNpmTasks 'grunt-bowercopy'

  # clean db
  grunt.registerTask 'dropDatabase', 'drop the database', ->
    done = this.async()
    db.connection.on 'open', ->
      db.connection.db.dropDatabase (err)->
        if err then console.log err else console.log 'Successfully dropped database'
        mongoose.connection.close done


  # generate Magazine
  grunt.registerTask 'generateMagazine', 'generate hpub and print', ->
    #remake all magazines and pages
    child_process = require("child_process").spawn
    spawn = child_process("rm", ["-r", 'books'], cwd: "./public/")
    spawn.on "exit", (code) ->
      if code isnt 0
        console.log "remove Magazines  exited with code " + code
      else
        fs.mkdirSync "./public/books"
        Magazine.find().execFind (err, data) ->
          for d in data
            fs.mkdirSync "./public/books/" + d.name
            fs.copySync "./components/" + d.theme + "/magazine/gfx", "./public/books/" +  d.name + "/hpub/gfx"
            fs.copySync "./components/" + d.theme + "/magazine/css", "./public/books/" +  d.name + "/hpub/css"
            fs.copySync "./components/" + d.theme + "/magazine/js", "./public/books/" +  d.name + "/hpub/js"
            fs.copySync "./components/" + d.theme + "/magazine/images", "./public/books/" +  d.name + "/hpub/images"
            HpubGenerator.generate d

  grunt.registerTask 'backupDatabase', 'backup the database', ->
    done = this.async()
    spawn = require('child_process').spawn
    mongoexport = spawn('mongodump', ['-d', config.dbname]).on 'exit', (code)->
      if code is 0
        console.log("Backupped Database");
      else
        console.log('Error: while backupDatabase, code: ' + code)
      done()

  grunt.registerTask 'restoreDatabase', 'restore the database', ->
    done = this.async()
    spawn = require('child_process').spawn
    mongoexport = spawn('mongorestore', ['-d', config.dbname], cwd: __dirname+'/dump').on 'exit', (code)->
      if code is 0
        console.log("Restored Database");
      else
        console.log('Error: while restoreDatabase, code: ' + code)
      done()

  grunt.registerTask 'install', 'Install the App', [
    'bower:install'
    'gitclone:baker:clone'
    'clean:baker'
    'mkdir:all'
    'bowercopy'
    'copy:tinymce' # translations for tinymce
    'clean:lib' #workaround ;()
    'build'
  ]

  grunt.registerTask 'reinstall', 'Reinstalling the App', [
    'dropDatabase'
    'clean:reinstall'
    'install'
  ]
  grunt.registerTask 'reset', 'Reinstalling the App', [
    'dropDatabase'
    'clean:everything'
  ]

  grunt.registerTask 'build', 'Compiles all of the assets and copies the files to the build directory.', [
    'clean:build'
    'requirejs'
  ]

  grunt.registerTask 'buildFrontend', 'Compiles all of the assets and copies the files to the build directory.', [
    'clean:buildFrontend'
    'requirejs:frontend'
  ]

  grunt.registerTask 'buildBackend', 'Compiles all of the assets and copies the files to the build directory.', [
    'clean:buildBackend'
    'requirejs:backend'
  ]

  grunt.registerTask 'test', 'Test the App with Jasmine and JSONlint, Coffeelint', [
    'jsonlint'
    'coffeelint'
    'jasmine'
  ]

  return grunt
