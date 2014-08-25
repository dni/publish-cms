require.config({
  baseUrl: 'vendor',
  paths: {
    lib: '../lib',
    utilities: '../utilities',
    modules: '../modules',
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
require(['text!../configuration.json', 'backbone'], function(configJSON, Backbone){

    setTimeout(function(){
      Backbone.history.start();
    }, 3000);

    var config = JSON.parse(configJSON);
    require(config.backend_modules, function(){
      for(var i = 0; i < arguments.length;i++) {
        arguments[i].init();
      }
    });
});
