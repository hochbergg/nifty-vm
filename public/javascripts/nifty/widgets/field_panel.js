Nifty.widgets.FieldPanel = Ext.extend(Ext.Panel, {
	fieldlets: [],
	subtitle: null,
	entityStore: null,
	fieldId: null,
	default_instances: 1,
	maximum_instances: null,
    baseCls : 'x-panel-nifty-field',
    collapsedCls : 'x-panel-nifty-field-collapsed',
	lastInstance: -1,
	
	// Override other inherited methods 
    onRender: function(){
   
        // Before parent code
		this.load();
   
        // Call parent (required)
        Nifty.widgets.FieldPanel.superclass.onRender.apply(this, arguments);
   
        // After parent code
	}, 
	
	load: function(){
		
		field = Nifty.pages.EntityPage.entityStore.fields[this.fieldId];
		
		if(field == null){
			return this.addEmptyInstances();
		}
		
		for(instance in field){
			this.addInstance({id: instance,field: field[instance], fieldlets: this.fieldlets});
		}
	
	},
	
	addEmptyInstances: function(){
		this.addInstance({id: (this.lastInstance + 1), fieldlets: this.fieldlets});
		return true;
	},
	
	addInstance: function(options){
		this.lastInstance = parseInt(options.id);
		
		this.add(
				new Nifty.widgets.FieldInstancePanel({instanceId: options.id,
													  field: options.field,
													  items: options.fieldlets
				})
			)
	},
	
	removeInstance: function(instance_id){
		console.log("removing: " + instance_id);
	}
});
