require(["backbone", "cs!utils"],function(Backbone, Utils){
    var start = function(){ Backbone.history.start(); }
    Utils.Vent.on("app:ready", start);
    // TODO fire app ready event ->
    setTimeout(start, 2000);
});
