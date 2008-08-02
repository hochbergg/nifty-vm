// Namespace
Nifty.widgets.fieldlets = {};


// Simple string display fieldlet

Nifty.widgets.fieldlets.StringFieldlet = Ext.extend(Nifty.widgets.Fieldlet,{
	cls: 'x-nifty-string-fieldlet',
		
	// set the display item template
	displayItem: '{value}',
	
	// edit item: simple text field
	editItem: {xtype: 'textfield'}
})
