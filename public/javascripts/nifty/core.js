/**
  * Nifty Core Application
  * by Shlomi Atar
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


// create application
Nifty.app = function() {
    // do NOT access DOM from here; elements don't exist yet
 	
	
    // private variables
 
    // private functions

	function hideLoaders(){
		 setTimeout(function(){
		    	Ext.get('loading').remove();
		    	Ext.get('loading-mask').fadeOut({remove:true});
		    }, 250);
	}
	
    // public space
    return {
        init: function() {
	
			this.setStatus('Loading Schema...');
			Nifty.schema.Loader.on('load', this.finishLoading, this);
			Nifty.schema.Loader.load({id: Nifty.viewerInfo.schema});
			
	 	},
	
		finishLoading: function(){
			
			// Hide Loader
			hideLoaders();
			this.setApplicationTitle();
			
			// Setup the router
			Nifty.Router.registerUrlPolling();
		},
		
		setStatus: function(statusMessage){
			Ext.fly('loading_status').update(statusMessage);
		},
		
		setApplicationTitle: function(){
			Ext.fly('app-name').update(Nifty.schema.loaded['name']);
		}
	}
}(); // end of app
 