Nifty.widgets.FieldInstancePanel = Ext.extend(Ext.Container, {
	fieldlets: [],
	field: null,
	instanceId: null,
	border: false,
	autoEl: {tag: 'div', cls: 'x-nifty-field-instance'},
	
	initComponent: function(){
		// set the ids & values of the fieldlets
		Ext.each(this.items,function(item){
			item.xtype = 'Fieldlet' + item.kind;
			item.formId = String.format('entity[{0}][{1}]', item.kind, this.instanceId);
			item.instance = this;
			if(this.field && this.field[item.xtype]){
				item.value = this.field[item.xtype].value;
			}
		}, this);
		
		Nifty.widgets.FieldInstancePanel.superclass.initComponent.apply(this, arguments);
	},
	
	// Override other inherited methods 
    onRender: function(){

		
        // Call parent (required)
        Nifty.widgets.FieldInstancePanel.superclass.onRender.apply(this, arguments);
        // After parent code
		
	},
	
	// mark self with "dirty" class
	setDirty: function(){
		this.addClass('x-nifty-field-instance-dirty')
	}
	
});

Ext.reg('fieldInstance', Nifty.widgets.FieldInstancePanel);