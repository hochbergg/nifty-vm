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
			        url: String.format('{0}/entities/{1}.js', this.getNamespace(), options.id),
			        success: this.loadRecords,
			 	   	failure: this.failedLoading,
			        method: 'get',
			 	   	scope: this
			      });
			
			return true;
		},
		
		
		getNamespace: function(){
			if(this.namespace){return this.namespace};
			var schema = Nifty.schema.loaded;
			
			if(schema.preferences && schema.preferences.routing){
				var ns = schema.preferences.routing.match(/^\/\w+/)
				
				if(ns){return this.namespace = ns}
			}
			return (this.namespace = '');
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
			
			return true;
		}
		
	})