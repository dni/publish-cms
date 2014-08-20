require(['text!../configuration.json', 'backbone'], function(configJSON, Backbone){
    Backbone.history.start();
    var config = JSON.parse(configJSON);
    require(config.backend_modules, function(){
      for(var i = 0; i < arguments.length;i++) {
        arguments[i].init();
      }
    });
});
