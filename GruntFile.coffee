config = require "./configuration.json"

mongoose = require "mongoose"
db = mongoose.connect 'mongodb://localhost/'+config.dbname
Magazine = require __dirname+"/components/backend/modules/magazine/model/MagazineSchema"
HpubGenerator = require __dirname + "/components/backend/modules/magazine/generators/HpubGenerator"
fs = require "fs-extra"
forever = require 'forever-monitor'


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
          "io.js": "socket.io-client/dist/socket.io.js"
          "jquery.js": "jquery/dist/jquery.js"
          "require.js": "requirejs/require.js"
          "jquery.ui.js": "jquery-ui/jquery-ui.js"
          "jquery.form.js": "jquery-form/jquery.form.js"
          "underscore.js": "underscore/underscore.js"
          "wreqr.js": "backbone.wreqr/lib/backbone.wreqr.js"
          "babysitter.js": "backbone.babysitter/lib/backbone.babysitter.js"
          "backbone.js": "backbone/backbone.js"
          "marionette.js": "marionette/lib/backbone.marionette.js"
          "localstorage.js": "backbone-localstorage/backbone-localstorage.js"
          "text.js": 'requirejs-text/text.js'
          "tpl.js": 'requirejs-tpl/tpl.js'
          "cs.js": 'require-cs/cs.js'
          "i18n.js": 'requirejs-i18n/i18n.js'
          "coffee-script.js": 'coffee-script/extras/coffee-script.js'
          "d3.js": 'd3/d3.js'
          "notify.js": 'notifyjs/dist/notify-combined.min.js'
          # Folders
          "css": 'require-css'
          "tinymce": "tinymce-builded/js/tinymce"
          "minicolors": 'jquery-minicolors'
          "fancybox": "fancybox/source"
          "jcrop": "jcrop"
          "bootstrap": "bootstrap"
          "require-less": 'require-less'


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
          baseUrl: './components/backend'
          fileExclusionRegExp: /^(server|spec)/
          mainConfigFile: "components/backend/config.js"
          dir: "cache/build/backend"
          stubModules: ['cs', 'css', 'less', 'i18n']
          modules: [{
            name: 'main'
            exclude: ['coffee-script', 'i18n', 'css', 'less']
          }]
      frontend:
        options:
          baseUrl: './components/frontend'
          fileExclusionRegExp: /^(server|spec)/
          mainConfigFile: "components/frontend/config.js"
          dir: "cache/build/frontend"
          stubModules: ['cs', 'css', 'less']
          modules: [{
            name: 'main'
            exclude: ['coffee-script', 'css', 'less']
          }]

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


  # fix libs
  grunt.registerTask 'fixLibs', ->
    fs.copySync "./fixes/i18n.js", "./components/backend/vendor/i18n.js"

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



  grunt.registerTask 'start', 'Start the server', ->
    production = new forever.Monitor "server.coffee",
      max: 3
      silent: true
      options: [
        max: 2 # Sets the maximum number of times a given script should run
        command: "coffee" # Binary to run (default: 'node')
        options: [config.productionPort]
        logFile: "cache/production-log.txt" # Path to log output from forever process (when daemonized)
        outFile: "cache/production-out.txt" # Path to log output from child stdout
        errFile: "cache/production-err.txt" # Path to log output from child stderr
      ]

    development = new forever.Monitor "server.coffee",
      max: 3
      silent: true
      options: [
        max: 2 # Sets the maximum number of times a given script should run
        command: "coffee" # Binary to run (default: 'node')
        options: [ config.developmentPort ]
        logFile: "cache/development-log.txt" # Path to log output from forever process (when daemonized)
        outFile: "cache/development-out.txt" # Path to log output from child stdout
        errFile: "cache/development-err.txt" # Path to log output from child stderr
      ]
    production.start()
    development.start()

  grunt.registerTask 'stop', 'Stop the server', ->
    # production.stop()
    # development.stop()

  grunt.registerTask 'restart', 'Restart the server', [ "stop", "start" ]

  grunt.registerTask 'install', 'Install the App', [
    'bower:install'
    'gitclone:baker:clone'
    'clean:baker'
    'mkdir:all'
    'bowercopy'
    'copy:tinymce' # translations for tinymce
    'clean:lib' #workaround ;()
    'fixLibs' # https://github.com/requirejs/i18n/issues/21
    'build'
    #'forever:production:start'
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

  grunt.registerTask 'restart', 'Restart the app daemon', [
    # 'forever:production:stop'
    # 'forever:production:start'
  ]

  grunt.registerTask 'reloadSettings', 'Reloading for settings', [
    #'build'
    # 'forever:server1:restart'
  ]

  return grunt
