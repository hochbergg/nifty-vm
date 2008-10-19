/*
 * Nifty-VM Ext frontend
 * Copyright(c) 2007-2008, Shlomi Atar
 * 
 * http://www.niftykm.com
 */

/**
 * @class Nifty.data.Schema 
 * A wrapper for the loaded schema
 * 
 * @param {Object} schema_hash Hash representation of the schema, recived from
 * 																	the server
 * 
 * @constructor
 */ 
Nifty.data.Schema = function(schema_hash){
	this.id	  			 = schema_hash.id;
	this.name 			 = schema_hash.name;
	this.preferences = schema_hash.preferences;
	this.elements 	 = schema_hash.elements;
	
	//constructors for each class
	this.elementConstructors = {};
	
	// list of the entities in this schema
	this.entities = [];
	
	// get the list of entities
	this.extractEntityList();
};

// Instance methods
Nifty.data.Schema.prototype = {
	
	/**
	 * Extracts the entities from the elements and pushs
	 * them into the entities list
	 */ 
	extractEntityList: function() {
		for(var k in this.elements){
			e = this.elements[k];
			if(e.type === 'entity'){this.entities.push(e)}
		}
	},
	
	
	/**
	 * Prepare and xtype-register the given element and his
	 * siblings
	 * 
	 * @param {String} id The element id for the element to generate for
	 * 
	 * @return {Object} the generated constructor
	 */ 
	prepareAndRegister: function(id) {
	 	var id = String(id); //force string keys
		
		// Check if the constructor is already cached
		if(this.elementConstructors[id]){return this.elementConstructors[id]};
		
		// the information from the viewer info
		var element = Nifty.viewerInfo.elements[id] || {};
		
		// information from the schema
		var schema_element = this.elements[id];
		
		// Apply the schema options 
		if(schema_element){Ext.apply(element,schema_element)};
		
		// sets the dependencies
		element.dependent = element.children;
		
		// recursively create all the siblings
		this.setupDepenencies(element);
		
		return this.createConstructor(element);
	},
	
	/**
	 * Prepare and register the dependencies of a given element
	 * 
	 * @param {Object} element The element to load his dependencies
	 */ 
	setupDepenencies: function(element){
		if(!element.dependent || element.dependent.length < 0){return;};
		
		Ext.each(element.dependent, function(dependent_id){
			this.prepareAndRegister(dependent_id);
		}, this);
	},
	
	/**
	 * Creates a constructor for the given element, based on his type
	 * 
	 * <p>The constructor is being registered and pushed into the cache</p>
	 * 
	 * @param {Object} element Element to create constructor for
	 * 
	 * @return {Object} constructor for the given element
	 */ 
	createConstructor: function(element) {
		if(element['type'] === 'fieldlet'){return;} //pass if fieldlet
		
		var constructor = Nifty.widgets[element['type']];
		
		// Change id to identifier
		element.identifier = element.id;
		delete element.id;
		
		// Create constructor
		klass = (this.elementConstructors[id] = Ext.extend(constructor,element));
		
		// register xtype
		Ext.reg(id, klass);
		
		// call on dependent siblings
		return klass;
	};
};
