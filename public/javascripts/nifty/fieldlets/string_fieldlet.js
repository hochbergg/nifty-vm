// Namespace
Nifty.widgets.fieldlets = {};


// Simple string display fieldlet

Nifty.widgets.fieldlets.StringFieldlet = Ext.extend(Nifty.widgets.Fieldlet,{
		
	// set the display item to be a span
	di: {xtype:'box'},
	
	// edit item: simple text field
	ei: {xtype: 'textfield'},
	
	
	setDisplayValue: function(value){;
		return {autoEl: {tag: 'span', html: value}};
	},
	
	setEditValue: function(value){
		return {value: value};
	},
})
