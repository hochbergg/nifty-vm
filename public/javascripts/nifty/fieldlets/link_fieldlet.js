// Simple string display fieldlet

Nifty.widgets.fieldlets.Link = {
	cls: 'x-nifty-link-fieldlet',
		
	// set the display item template
	displayTpl: ['<tpl for="value">', 
	'<a href="#/entities/{id}" class="entity-link icon-small-{entity_type}">{display}</a>',
	'</tpl>'],
	

	
	// edit item: simple text field
	editCmp: {xtype: 'textfield'}
	
};