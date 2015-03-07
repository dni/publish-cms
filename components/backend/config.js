require.config({
  baseUrl: 'vendor',
  paths: {
    lib: '../lib',
    utilities: '../utilities',
    modules: '../modules',
    configuration: '../configuration.json',
    App: "../utilities/App",
    Publish: "../lib/Publish",
    Router: '../utilities/Router',
    Utils: '../utilities/Utilities',
    tinymce: 'tinymce/tinymce',
    'jquery.tinymce': 'tinymce/jquery.tinymce.min',
  },
  shim: {
    'jquery.tinymce':['jquery', 'tinymce'],
    'minicolors':['jquery'],
  }
});
require(['cs!App','text!configuration', 'backbone', 'jquery'], function(App, configJSON, Backbone, $){
    $(document).off('.data-api');
    var config = JSON.parse(configJSON).backend_modules;
    require(config, function(){
      for(var i = 0; i < arguments.length;i++) {
        arguments[i].init();
      }
    });
    App.vent.on('ready', function(){
      console.log("App is now ready");
      Backbone.history.start();
    });
});
