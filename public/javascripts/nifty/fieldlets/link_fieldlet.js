// Simple string display fieldlet

Nifty.widgets.fieldlets.LinkFieldlet = Ext.extend(Nifty.widgets.Fieldlet,{
		
	// set the display item to be a span
	displayItem: '<a href="#/entities/{[values.value.id]}">{[values.value.display]}</a>',
	
	// edit item: simple number-only field
	editItem: {xtype: 'textfield'},
	
	defaultValue: {},
	
	setEditValue: function(item, value){
		item.setValue(value.id);
	},
	
	// overrideable
	getEditValue: function(){
		return {id: this.getEditCmp().getValue(), display: 'link', kind: ''};
	}
	
})
