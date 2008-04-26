// Namespace
Nifty.widgets.fieldlets = {};


// Simple string display fieldlet

Nifty.widgets.fieldlets.StringFieldlet = Ext.extend(Nifty.widgets.Fieldlet,{
		
	// set the display item to be a span
	di: new Ext.XTemplate('{value}'),
	
	// edit item: simple text field
	ei: {xtype: 'textfield'},
})
