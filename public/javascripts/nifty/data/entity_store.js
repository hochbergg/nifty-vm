/*
* @class Nifty.data.Entity
*
*
*/

Nifty.data.currentStore = null;

Nifty.data.EntityStore = function(){
		this.addEvents(
			'beforeload',
			'load',
			'loadexception'
			);
			
		Nifty.data.EntityStore.superclass.constructor.call(this);
		
		Nifty.data.currentStore = this; // set as current
	}
	
	Ext.extend(Nifty.data.EntityStore, Ext.util.Observable,{
		// Loads the entity from the server
		load: function(options){
			this.prepare(); // setup somethings
			

			options = options || {};
			if(this.fireEvent("beforeload", this, options) === false){return false;};
			
			 // Ajax Request
			 Ext.Ajax.request({
			        url: '/entities/' + options.id + '.js',
			        success: this.loadRecords,
			 	   	failure: this.failedLoading,
			        method: 'get',
			 	   	scope: this
			      });
			
			return true;
		},
		
		
		// setup and clean up things
		prepare: function(){
			
		},
		
		loadRecords: function(response, options){
		   this.data = Ext.util.JSON.decode(response.responseText);
		   
		   this.fields = this.data['fields'];
	
		   this.setupStores();
		
		   this.fireEvent("load", this, this.data,options);
		},
		
		failedLoading: function(){
			
		},
		
		
		// will create stores for this entity's fields
		setupStores: function(){
			this.stores = {};
			
			if(!Nifty.schema.loaded){this.fireEvent("loadexception", this); return false;};
			
			var fields = Nifty.schema.loaded.elements[this.data.type].children;
			
			Ext.each(fields, function(key){
				// fetch the field
				var field = Nifty.schema.loaded.elements[key];
				this.stores[key] = new Nifty.data.FieldStore({fieldlets: field.children, storeId: key});
			},this);
			
			console.log(this.stores)
			return true;
		}
		
	})








///
////**
/// * @class Nifty.data.EntityStore
/// * @extends Ext.util.Observable
/// * @constructor
/// * Creates a new Store.
/// * @param {Object} config A config object containing the objects needed for the Store to access data,
/// * and read the data into Records.
/// */
///Nifty.data.EntityStore = function(config){
///
///    Ext.apply(this, config);
///
///    this.addEvents(
///        /**
///         * @event beforeload
///         * Fires before a request is made for a new data object.  If the beforeload handler returns false
///         * the load action will be canceled.
///         * @param {Store} this
///         * @param {Object} options The loading options that were specified (see {@link #load} for details)
///         */
///        'beforeload',
///        /**
///         * @event load
///         * Fires after a new set of Records has been loaded.
///         * @param {Store} this
///         * @param {Object} options The loading options that were specified (see {@link #load} for details)
///         */
///        'load',
///        /**
///         * @event loadexception
///         * Fires if an exception occurs in the Proxy during loading.
///         * Called with the signature of the Proxy's "loadexception" event.
///         */
///        'loadexception'
///    );
///
///
///	this.fields = {}; //clear the fields
///	this.data = {} // empty data
///	
///    Nifty.data.EntityStore.superclass.constructor.call(this);
///
///};
///Ext.extend(Nifty.data.EntityStore, Ext.util.Observable, {
///    
///
///    load : function(options){
///		this.clear();
///
///        options = options || {};
///        if(this.fireEvent("beforeload", this, options) !== false){
///
///			// Ajax Request
///			Ext.Ajax.request({
///			       url: '/entities/' + options['id'] + '.js',
///			       success: this.loadRecords,
///				   failure: this.failedLoading,
///			       method: 'get',
///				   scope: this
///     	     });
///
///
///            return true;
///        } else {
///          return false;
///        }
///    },
///
///	
///	failedLoading: function(options){
///		//console.warn('failed loading: ' + options['id']);
///		this.fireEvent("loadexception", this, options);
///	},
///	
///    // private
///    // Called as a callback by the Reader during a load operation.
///    loadRecords : function(response,options){
///		this.data = Ext.util.JSON.decode(response.responseText)
///		
///		this.fields = this.data['fields'];
///
///        this.fireEvent("load", this, this.data,options);
///    },
///	
///	// manually set the type of the entity
///	setNew: function(type){
///		this.clear();
///		this.data.type = type;
///		this.data.isNew = true;
///	},
///	
///	clear: function(){
///		this.data = {};
///		this.fields = {};
///		this.fieldlets = {};
///	}
///
///});