

// Simple string display fieldlet

Nifty.widgets.fieldlets.Text = Ext.extend(Nifty.widgets.Fieldlet,{
	cls: 'x-nifty-text-fieldlet',
		
	// set the display item template
	displayItem: '{value}',
	
	// edit item: simple text field
	editItem: {xtype: 'textarea', width: 300, height: 100},
	

})
