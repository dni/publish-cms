require.config({
  baseUrl: "frontend/vendor",
  paths: {
    modules: "../modules",
    utilities: "../utilities",
  },
  shim: {
    'jquery.fancybox':['jquery']
  },
});

require([
  'backbone',
  'jquery',
  'cs!modules/blog/BlogModule'
], function(Backbone, $){
  setTimeout(function(){ Backbone.history.start()}, 400);
  $(document).off('.data-api');
});
