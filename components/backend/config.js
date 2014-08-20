require.config({
  baseUrl: 'components/backend/',
	paths: {
		App: "utilities/App",
		Publish: "lib/Publish",
		Settings: 'modules/settings/model/Settings',
		Router: 'utilities/Router',
		utils: 'utilities/Utilities',
		io: "vendor/io",
		jquery: "vendor/jquery",
		"jquery.ui": "vendor/jquery.ui",
		tinymce: "vendor/tinymce/tinymce.min",
		"jquery.tinymce": "vendor/tinymce/jquery.tinymce.min",
		"jquery.jcrop": "vendor/jcrop/js/jquery.Jcrop",
		"jquery.form": "vendor/jquery.form",
		underscore: "vendor/underscore",
		wreqr: "vendor/wreqr",
		babysitter: "vendor/babysitter",
		backbone: "vendor/backbone",
		bootstrap: "vendor/bootstrap/dist/js/bootstrap",
		marionette: "vendor/marionette",
    localstorage: "vendor/backbone-localstorage",
		text: 'vendor/text',
		tpl: 'vendor/tpl',
		i18n: 'vendor/i18n',
		d3: 'vendor/d3',
		minicolors: 'vendor/minicolors/jquery.minicolors',
		notifyjs: 'vendor/notify'
	},
	map: {
	    '*': {
	        'backbone.wreqr': 'wreqr',
	        'backbone.babysitter': 'babysitter',
	    }
	},
	packages: [
      {
        name: 'less',
        location: 'vendor/require-less',
        main: 'less'
      },{
	    name: 'cs',
	    location: 'vendor',
	    main: 'cs'
	  },{
	    name: 'css',
	    location: 'vendor/css',
	    main: 'css'
	  },{
	    name: 'coffee-script',
	  	location: 'vendor',
	    main: 'coffee-script'
	  }
    ],
	shim: {
		'jquery.ui':['jquery'],
		'jquery.jcrop':['jquery'],
		'jquery.tinymce':['jquery', 'tinymce'],
		'jquery.form':['jquery'],
		'bootstrap':['jquery'],
		'minicolors':['jquery'],
	}
});

require(['text!configuration.json', 'main'], function(configJSON){
    var config = JSON.parse(configJSON);
    require(config.backend_modules, function(){
        for(var i = 0; i < arguments.length;i++) {
            try {
                arguments[i].init();
            } catch(e) {
                // TODO
                // MODULES NEED TO BE UPDATED so they work here^^
                // Only Mymodule should work now
                // console.log(e);
            }
        }
    });
});
