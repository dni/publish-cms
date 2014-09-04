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
  Backbone.history.start();
  $(document).off('.data-api');
});
