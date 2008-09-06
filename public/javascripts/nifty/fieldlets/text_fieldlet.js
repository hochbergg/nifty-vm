

// Simple string display fieldlet

Nifty.widgets.fieldlets.Text = {
	cls: 'x-nifty-text-fieldlet',
		
	// set the display item template
	displayTpl: '{value}',
	
	// edit item: simple text field
	editCmp: {xtype: 'textarea', width: 500, height: 100, grow: true}
	
}
