/**
  * Nifty Core Application
  * by Shlomi Atar
  */
 

Ext.namespace('Nifty',
			  'Nifty.data',
			  'Nifty.widgets');



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
			// Hide Loader
			hideLoaders();
			
			Nifty.Router.registerUrlPolling();
	 	},
	}
}(); // end of app
 