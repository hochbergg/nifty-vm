/*
 * Nifty-VM Ext frontend
 * Copyright(c) 2007-2008, Shlomi Atar
 * 
 * http://www.niftykm.com
 */

/**
 * Setup namespaces 
 */

Ext.namespace('Nifty.schema',
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
 * Setup the main app code
 * <p>The main app (Nifty.app) is called when the page has finished its loading.
 * The main app code loads the current schema from the server, sets up the
 * application title, register the internal url router ({@link Nifty.Router})
 * and hides the "Loading" masks</p>
 */
Nifty.app = function() {
  
	// Private

  /**
   * Hides the "loading" masks (after 250ms delay)
	 *
   */
	function hideLoaders(){
		 setTimeout(function(){
		    	Ext.get('loading').remove();
		    	Ext.get('loading-mask').fadeOut({remove:true});
		    }, 250);
	}
	
  // Public space
  return {
    
		/**
     * Starts the schema loading process and register loading events
		 * <p>The schema id used from the viewer info, loaded in a script tag
		 * when the page is loaded</p>
		 * 
		 * see {@link Nifty.schema.Loader}
     */
		init: function() {
	
			this.setStatus('Loading Schema...');
			Nifty.schema.Loader.on('load', this.finishSchemaLoading, this);
			Nifty.schema.Loader.load({id: Nifty.viewerInfo.schema});
	 	},
	
	
		/**
     * A Callback called when the schema loader has finished loading the
		 * schmea.
		 *
		 * <p>Hides the loaders, sets the application title and  setups the 
		 * router</p>
		 * 
		 * see {@link Nifty.Router}
     */
		finishSchemaLoading: function(){
			
			// Hide Loader
			hideLoaders();
			
			// Set application title
			this.setApplicationTitle();
			
			// Setup the router
			Nifty.Router.registerUrlPolling();
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
			Ext.fly('app-name').update(Nifty.schema.loaded['name']);
		}
	}
}(); // run the method and have access only to the public mehtods
 