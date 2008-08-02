Nifty.widgets.FieldContainer = Ext.extend(Ext.Container, {
	// initialize fieldlets
	instanceLayout: [],
	
	// defalut seperator
	seperator: {xtype: 'box', autoEl: {tag: 'br'}},

	// autoElement generation for the Ext.Container
	autoEl: {tag: 'div', cls: 'x-panel-nifty-field'},
	
	// used with the form layout
	isFormField: true,
	
	// Override other inherited methods 
    onRender: function(){
		// load the field data from the entity store
		
		this.setupHeader();
		
		this.load();
		
		this.setupFooter();
   
        // Call parent (required)
        Nifty.widgets.FieldContainer.superclass.onRender.apply(this, arguments);
   
        // After parent code

		// set as edit if this is new entity
		this.setEditIfnew();
	}, 
	
	// load the field data from the entity store
	load: function(){
		// we can't load anything if we have no fieldId
		if(!this.fieldId)
			return; 
		
		if(!this.store)
			this.store = Nifty.pages.current.entityStore
		
		this.data = this.store.fields[this.fieldId];
		
		if(this.data == null){
			return this.addEmptyInstances();
		}

		// add instnaces 
		for(instance=0;instance<this.data.length;instance++){
			this.addInstance(this.data[instance]);
		}
	
	},
	
	
	// add the header to the items
	setupHeader: function(){
		if(!this.header)
			return;
		
		this.add(this.header);
	},
	
	setupFooter: function(){
		if(!this.footer)
			return;
		
		this.add(this.footer);
	},
	
	addEmptyInstances: function(){
		this.addInstance({});
		return true;
	},
	
	addInstance: function(data){
		this.addSeperatorIfNeeded();
		this.add({
					data: data,
					instanceLayout: this.instanceLayout,
					xtype: 'fieldInstance'
				});
	},
	
	// will add the seperator only if the last element on the items is
	// another fieldInstance! 
	addSeperatorIfNeeded: function(){
		if(this.items && this.items.last().initialConfig.xtype == 'fieldInstance'){
			this.add(this.seperator);
		}
	},
	
	removeInstance: function(instance_id){
	//	console.log("removing: " + instance_id);
	},
	
	toggleEdit: function(){
		if(this.editing){
			this.removeClass('x-panel-nifty-field-edited');	
			this.editing = false;
		} else {
			// call the beforeEdit for each instance
			this.items.each(function(item){
				if(item.beforeEnteringEditMode){
					item.beforeEnteringEditMode();
					}
			});			
			
			this.addClass('x-panel-nifty-field-edited');
			this.editing = true;	
		}
	},
	
	
	// check if new, if true, set as edit
	setEditIfnew: function(){
		if (this.store.data.isNew)
			this.toggleEdit();
	}
});