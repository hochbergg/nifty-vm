/*
* Nifty Schema loader
*
*
*/

// Hash for loaded schema.
Nifty.schema.loaded = null;

Nifty.schema.useWindowNameCache = false;

// Schema Loader - singleton
Nifty.schema.Loader = function(){
	
	// private stuff
	
	// schema class
	
	var Schema = function(schema_hash){	
		this.id = schema_hash.id;
		this.name = schema_hash.name;
		this.preferences = schema_hash.preferences;
		this.elements = schema_hash.elements;
		this.elementConstructors = {}; //constructors for each class;
		this.entities = [];
		
		// iterate over all the elements, push the entities into the entities array
		for(var k in this.elements){
			e = this.elements[k];
			if(e.type === 'entity'){this.entities.push(e)}
		}
		
		// will prepare and xtype-register the given element and all his siblings
		this.prepareAndRegister = function(id){
			id = String(id) //for problems with object keys etc..
			if(this.elementConstructors[id]){return this.elementConstructors[id];} // if generated
			
			var element = Nifty.viewerInfo.elements[id] || {};		
			
			// merge the schema options
			var schema_element = this.elements[id];
			
			
			if(schema_element){
				Ext.apply(element, schema_element);
			}
			
			element.dependent = element.children;
			
			// recursively create all the siblings
			if(element.dependent && element.dependent.length > 0){
				Ext.each(element.dependent, function(dependent_id){
					this.prepareAndRegister(dependent_id);
				}, this);
			};
			
			// clone constructor and add elements.
			// add to the cache
			if(element['type'] === 'fieldlet'){return;} //pass if fieldlet
			
			var constructor = Nifty.widgets[element['type']];
						
			element.identifier = element.id;
			delete element.id;
			
			klass = (this.elementConstructors[id] = Ext.extend(constructor,element));
			
			// register xtype
			Ext.reg(id, klass);
			
			// call on dependent siblings
			return klass;
		}
	}
	
	
	
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

	    load : function(options){
			

			
	        options = options || {};
	        if(this.fireEvent("beforeload", this, options) !== false){
				// use window.name cache
				if(Nifty.schema.useWindowNameCache && window.name.length > 0){
					// try to load with 
					schema_pos = window.name.indexOf(options['id']);
					
					if(schema_pos > -1){
						this.setupSchema(window.name, {});
						return;						
					}
				}
				
				// Ajax Request
				Ext.Ajax.request({
				       url: 'schema.js',
				       success: this.loadRecords,
					   failure: this.failedLoading,
				       method: 'get',
					   scope: this
	     	     });


	            return true;
	        } else {
	          return false;
	        }
	    },


		failedLoading: function(options){
			//console.warn('failed loading: ' + options['id']);
			this.fireEvent("loadexception", this, options);
		},

	    // private
	    // Called as a callback by the Reader during a load operation.
	    loadRecords : function(response,options){
			var response = response.responseText;
			
			if(Nifty.schema.useWindowNameCache){window.name = response};
			
			this.setupSchema(response, options);
			
	    },
		
		setupSchema: function(schema_json, options){
			var result = new Schema(Ext.util.JSON.decode(schema_json));
			
			Nifty.schema.loaded = result;
			
			this.fireEvent("load", this, result,options);
	        
		}

	});
	

	return new loader();
}();



