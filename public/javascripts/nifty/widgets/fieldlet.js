

Nifty.widgets.Fieldlet = Ext.extend(Ext.Container,{
//	layout: 'column',
	autoEl: {tag: 'span'},
	
	// sets the value for the display and the edit field
	setValue: function(value){
		Ext.apply(this.displayItem, this.setDisplayValue(value));
		Ext.apply(this.editItem, this.setEditValue(value));
	},
	
	
	// sets the ID & the name for the form elemnt
	setId: function(id){
		Ext.apply(this.editItem, {id: id});
	},
		
	// overrideable
	setDisplayValue: function(value){
		return {};
	},
	
	// overrideable
	setEditValue: function(value){
		return {};
	},
	
	
	onRender: function(){

			
		
		Nifty.widgets.Fieldlet.superclass.onRender.apply(this, arguments);
		
	},
    
	initComponent : function(){
		Ext.apply(this, {
			displayItem: this.di,
			editItem: this.ei
		})
		
		this.setValue(this.value);
		this.setId(this.formId);

		if(!this.displayItem.cls)
			this.displayItem.cls = 'fieldlet-display-item';

		if(!this.editItem.cls)
			this.editItem.cls = 'fieldlet-edit-item';

        Nifty.widgets.Fieldlet.superclass.initComponent.call(this);

		this.add(this.displayItem);
		this.add(this.editItem);
	}
})