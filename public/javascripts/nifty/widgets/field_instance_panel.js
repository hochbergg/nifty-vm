Nifty.widgets.FieldInstancePanel = Ext.extend(Ext.Panel, {
	fieldlets: [],
	field: null,
	instanceId: null,
	border: false,
	
	
	// Override other inherited methods 
    onRender: function(){
  		// set the ids & values of the fieldlets
		this.items.each(function(item){
			item.id +=  ('[' + this.instanceId + ']')
			if(this.field && this.field[item.xtype])
				item.value = this.field[item.xtype].value			
		}, this);
				
		
        // Call parent (required)
        Nifty.widgets.FieldInstancePanel.superclass.onRender.apply(this, arguments);
        // After parent code
		
	}
	
});