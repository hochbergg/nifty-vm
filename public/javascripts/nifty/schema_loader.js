/*
 * Nifty-VM Ext frontend
 * Copyright(c) 2007-2008, Shlomi Atar
 * 
 * http://www.niftykm.com
 */


/**
 * @class Nifty.loaders.SchemaLoader 
 * @extends Ext.util.Observable
 * Loads the schema from the server and return schema object
 * <p>
 * </p>
 * @singleton
 */ 
Nifty.loaders.SchemaLoader = function(){
	
	
	// loader class
	var loader = function(config){
		Ext.apply(this, config);

	    this.addEvents(
	        'beforeload',
	        'load',
	        'loadexception'
	    );

	    loader.superclass.constructor.call(this);
	};
	
	Ext.extend(loader, Ext.util.Observable, {
		/**
		 * Loads the schema from the server
		 * @param {Mixed} options Options to pass to the schema loading mechanisem
		 */ 
		load : function(options){
			options = options || {}; // defaults
			
			// Fire the 'BeforeLoad' event
			if(this.fireEvent("beforeload", this, options) !== false){
			
				// Use AJAX requset to fetch the schema from the server
				Ext.Ajax.request({
					url: 'schema.js',
				  success: this.loadSchema,
					failure: this.failedLoading,
				  method: 'get',
					scope: this
	     	});
      	return true;
      } else {return false;}
	  },

		/**
		 * Called when the there is a problem with the loading mechanisem
		 * @param {Mixed} options The loading parameters of the loading action
		 */ 
		failedLoading: function(options){
			// Fire the loadexecption event
			this.fireEvent("loadexception", this, options);
		},

		/**
		 * Called after a succesful loading of the schema
		 * @param {Object} response The response object of the AJAX request
		 * @param {Mixed} options The loading options for the AJAX request
		 */ 
	  loadSchema : function(response,options){
			var json_response = response.responseText;
			
			this.setupSchema(json_response, options);
	  },
		
		/**
		 * Create new {@link Nifty.data.Schema} object from the given JSON response
		 * 
		 * @param {String} json_response json string from the AJAX Request
		 * @param {Mixed} options The loading options for the AJAX request
		 */ 
		setupSchema: function(json_response, options){
			var result = new Nifty.data.Schema(Ext.util.JSON.decode(json_response));
			
			this.fireEvent("load", this, result,options);
		}

	});
	

	return new loader();
}();