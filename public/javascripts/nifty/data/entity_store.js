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
		
		this.EntityCRUD = new Nifty.data.EntityCRUD({namespace: this.getNamespace()});
		this.saveTask = new Ext.util.DelayedTask(this.saveChanges,this);
	}
	
	Ext.extend(Nifty.data.EntityStore, Ext.util.Observable,{
		// Loads the entity from the server
		load: function(options){
			this.prepare(); // setup somethings
			

			options = options || {};
			if(this.fireEvent("beforeload", this, options) === false){return false;};
			
			 
			
			this.EntityCRUD.read(options.id,{
				onSuccess: this.loadRecords,
				onFailure: this.failedLoading,
				scope: this
			});
			
			this.autoFlush = true;
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
			alert("Cannot load!");
		},
		
		
		// will create stores for this entity's fields
		setupStores: function(){
			this.stores = {};
			
			if(!Nifty.schema.loaded){this.fireEvent("loadexception", this); return false;};
			
			var fields = Nifty.schema.loaded.elements[this.data.type].children;
			Ext.each(fields, function(key){
				// fetch the field
				var field = Nifty.schema.loaded.elements[key];
				var store = new Nifty.data.FieldStore({fieldlets: field.children, storeId: key});
				
				// register stores events
				store.on({
					'remove': this.storeCallbacks.onRemove,
					'add'	: this.storeCallbacks.onAdd,
					'update': this.storeCallbacks.onUpdate,
					scope: this
				})
				
				this.stores[key] = store;
			},this);
			
			this.clearQueues();
			return true;
		},
		
		
		storeCallbacks: {
			onRemove: function(store, record, index){
				this.removedRecords[record.id] = store.storeId;
				if(this.autoFlush){this.saveTask.delay(10);} // send saveChanges
			},
			
			onAdd: function(store, records, index){
			},
			
			onUpdate: function(store, record, operation){
				var changes = record.getChanges();

				var recordHash = {};
				for(var k in changes){
					recordHash[k.slice(1)] = changes[k];
				}
				this.updatedRecords[record.id] = recordHash;
				if(this.autoFlush){this.saveTask.delay(10);} // send saveChanges
			}
		},
		
		
		saveChangesCallbacks: {
			saveFailure: function(){
				
			},
			
			saveCompleted: function(){
				console.log('saved!');
				console.log(arguments)
				this.clearQueues();
			},
			
			createFailure: function(){
				
			},
			
			createComplete: function(){
				
			}
			
		},
		
		saveChanges: function(){
			var changesHash = {};
			
			for(var k in this.newRecords){
				if(!changesHash.new){changesHash.new = {}};
				changesHash.new[k] = this.newRecords[k];
			}
			
			for(var k in this.removedRecords){
				if(!changesHash.remove){changesHash.remove = {}};
				changesHash.remove[k] = this.removedRecords[k];
			}
			
			for(var k in this.updatedRecords){
				changesHash[k] = this.updatedRecords[k];
			}
			
			if(this.new){
				this.EntityCRUD.create(changesHash, {
					onSuccess: this.saveChangesCallbacks.createCompleted,
					onFailure: this.saveChangesCallbacks.createFailure,
					scope: this
				})
				return;
			}
			
			// check if there are values in the changes hash
			var empty = true;
			for(var k in changesHash){empty = false};
			if(empty){return}; // return if empty
			
			this.EntityCRUD.update(this.data.id, changesHash, {
				onSuccess: this.saveChangesCallbacks.saveCompleted,
				onFailure: this.saveChangesCallbacks.saveFailure,
				scope: this
			})
		},
		
		clearQueues: function(){
			this.newRecords = {};
			this.updatedRecords = {};
			this.removedRecords = {};
		}
		
	})