/*
 * Nifty-VM Ext frontend
 * Copyright(c) 2007-2008, Shlomi Atar
 * 
 * http://www.niftykm.com
 */

/**
 * Setup namespaces 
 */

Ext.namespace('Nifty.loaders',
			  			'Nifty.data',
			  			'Nifty.widgets',
			  			'Nifty.pages',
			  			'Nifty.widgets.fieldlets',
			  			'Nifty.entities',
			  			'Nifty.entities.actions',
			  			'Nifty.panels',
			  			'Nifty.fields',
			  			'Nifty.layout',
			  			'Nifty.cache',
			  			'Nifty.cache.elements',
			  			'Nifty.cache.pages'
						 );


/**
 * @class Nifty.BootLoader
 * Setup the main app code
 * <p>The main app (Nifty.app) is called when the page has finished its loading.
 * The main app code loads the current schema from the server, sets up the
 * application title, register the internal url router ({@link Nifty.Router})
 * and hides the "Loading" masks</p>
 *
 * @constructor
 */
Nifty.BootLoader = function(config){
  Ext.apply(this, config);

	this.load(); // start the loading process
};

Nifty.BootLoader.prototype = {
	
	/**
   * Hides the "loading" masks (after 250ms delay)
	 *
   */
	hideLoaders: function(){
		 setTimeout(function(){
		    	Ext.fly('loading').remove();
		    	Ext.fly('loading-mask').fadeOut({remove:true});
		 }, 250);
	},
	
	/**
   * Starts the schema loading process and register loading events
	 * <p>The schema id used from the viewer info, loaded in a script tag
	 * when the page is loaded</p>
	 * 
	 * see {@link Nifty.schema.Loader}
   */
	load: function(){
		this.setExtBaseOptions();

		this.setStatus('Loading Schema...');
		Nifty.loaders.SchemaLoader.on('load', this.finishSchemaLoading, this);
		Nifty.loaders.SchemaLoader.load();
 	},


	/**
   * A Callback called when the schema loader has finished loading the
	 * schmea.
	 *
	 * <p>Hides the loaders, sets the application title and  setups the 
	 * router</p>
	 *
	 * see {@link Nifty.Router}
	 *
	 * @param {Nifty.data.Schema} loaded_schema The loaded Schema
   */
	finishSchemaLoading: function(loader,loaded_schema){
		// Sets the current schema
		this.schema = loaded_schema;
		
		// Hide Loader
		this.hideLoaders();
		
		// Set application title
		this.setApplicationTitle();
		
		// Setup the router
		this.router = new Nifty.Router();
	},
	
	/**
   * Sets the status message of the loading indicator
	 * @param {String} statusMessage The status message to set
   */
	setStatus: function(statusMessage){
		Ext.fly('loading_status').update(statusMessage);
	},
	
	/**
   * Sets the application title according to the loaded schema
   */
	setApplicationTitle: function(){
		Ext.fly('app-name').update(this.schema.name);
	},
	
	/**
	 * Sets Ext's base options (blank images, qtips, state etc.)
	 */ 
	setExtBaseOptions: function(){
		// reference local blank image
		Ext.BLANK_IMAGE_URL = '/ext/resources/images/default/s.gif';
		//init qtips
    Ext.QuickTips.init();
	},
	
	/**
	 * Loads the page with the given id
	 *
	 * @param {String} id the page id to load 
	 */ 
	loadPage: function(id){
		    new Nifty.widgets.page(Nifty.viewerInfo.pages[id]);
	}
};
 
// When the document is fully loaded, Initiate the BootLoader
// and sets Nifty.app to be the instance of bootloader
Ext.onReady(function(){
	Nifty.app = new Nifty.BootLoader();
});

