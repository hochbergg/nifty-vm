Nifty.fieldlets.Fieldlet25 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Name'}
});
Ext.reg('Fieldlet25', Nifty.fieldlets.Fieldlet25);

Nifty.fieldlets.Fieldlet26 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Serial Number'}
});
Ext.reg('Fieldlet26', Nifty.fieldlets.Fieldlet26);

Nifty.fieldlets.Fieldlet27 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Price'}
});
Ext.reg('Fieldlet27', Nifty.fieldlets.Fieldlet27);

Nifty.fieldlets.Fieldlet28 = Ext.extend(Nifty.widgets.fieldlets.LinkFieldlet, {
	editItemOptions: {emptyText: 'Favorited By Customers'}
});
Ext.reg('Fieldlet28', Nifty.fieldlets.Fieldlet28);

Nifty.fieldlets.Fieldlet29 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Bought at'}
});
Ext.reg('Fieldlet29', Nifty.fieldlets.Fieldlet29);

Nifty.fieldlets.Fieldlet30 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'First Name'}
});
Ext.reg('Fieldlet30', Nifty.fieldlets.Fieldlet30);

Nifty.fieldlets.Fieldlet31 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Middle Name'}
});
Ext.reg('Fieldlet31', Nifty.fieldlets.Fieldlet31);

Nifty.fieldlets.Fieldlet32 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Last Name'}
});
Ext.reg('Fieldlet32', Nifty.fieldlets.Fieldlet32);

Nifty.fieldlets.Fieldlet33 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Type'}
});
Ext.reg('Fieldlet33', Nifty.fieldlets.Fieldlet33);

Nifty.fieldlets.Fieldlet34 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Contact'}
});
Ext.reg('Fieldlet34', Nifty.fieldlets.Fieldlet34);

Nifty.fieldlets.Fieldlet35 = Ext.extend(Nifty.widgets.fieldlets.LinkFieldlet, {
	editItemOptions: {emptyText: 'Favorite Products'}
});
Ext.reg('Fieldlet35', Nifty.fieldlets.Fieldlet35);

Nifty.fieldlets.Fieldlet36 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Bought at'}
});
Ext.reg('Fieldlet36', Nifty.fieldlets.Fieldlet36);

Nifty.fields.field15 = Ext.extend(Nifty.widgets.FieldContainer, {
	fieldId: '15',
	fieldLabel: 'Name',
	
	instanceLayout: [{kind: 25}]
	
})
Ext.reg('Field15', Nifty.fields.field15);			

Nifty.fields.field16 = Ext.extend(Nifty.widgets.FieldContainer, {
	fieldId: '16',
	fieldLabel: 'Serial Number',
	
	instanceLayout: [{kind: 26}]
	
})
Ext.reg('Field16', Nifty.fields.field16);			

Nifty.fields.field17 = Ext.extend(Nifty.widgets.FieldContainer, {
	fieldId: '17',
	fieldLabel: 'Price',
	
	instanceLayout: [{kind: 27}]
	
})
Ext.reg('Field17', Nifty.fields.field17);			

Nifty.fields.field18 = Ext.extend(Nifty.widgets.FieldContainer, {
	fieldId: '18',
	fieldLabel: 'Favorited By Customers',
	
	instanceLayout: [{kind: 28},{kind: 29}]
	
})
Ext.reg('Field18', Nifty.fields.field18);			

Nifty.fields.field19 = Ext.extend(Nifty.widgets.FieldContainer, {
	fieldId: '19',
	fieldLabel: 'Name',
	
	instanceLayout: [{kind: 30},{kind: 31},{kind: 32}]
	
})
Ext.reg('Field19', Nifty.fields.field19);			

Nifty.fields.field20 = Ext.extend(Nifty.widgets.FieldContainer, {
	fieldId: '20',
	fieldLabel: 'Contacts',
	
	instanceLayout: [{kind: 33},{kind: 34}]
	
})
Ext.reg('Field20', Nifty.fields.field20);			

Nifty.fields.field21 = Ext.extend(Nifty.widgets.FieldContainer, {
	fieldId: '21',
	fieldLabel: 'Favorite Products',
	
	instanceLayout: [{kind: 35},{kind: 36}]
	
})
Ext.reg('Field21', Nifty.fields.field21);			

Nifty.entities.kinds.push({id: 10, singleName: 'Order', multiName: 'Order'});

Nifty.panels['Entity10'] = {
	subtitle: 'Order',
	title: 'Loading',
	newItemTitle: 'New Order',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-10',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			defaults: {autoScroll:false},
			items: [
				{xtype: 'panel',
				 layout: 'niftyForm',
				 title: 'Information',
				 items: []
				}
			]
	}
};

Nifty.panels['Entity10side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.entities.kinds.push({id: 11, singleName: 'Customer', multiName: 'Customer'});

Nifty.panels['Entity11'] = {
	subtitle: 'Customer',
	title: 'Loading',
	newItemTitle: 'New Customer',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-11',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			defaults: {autoScroll:false},
			items: [
				{xtype: 'panel',
				 layout: 'niftyForm',
				 title: 'Information',
				 items: [{xtype: 'Field19'},{xtype: 'Field20'},{xtype: 'Field21'}]
				}
			]
	}
};

Nifty.panels['Entity11side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.entities.kinds.push({id: 12, singleName: 'Product', multiName: 'Product'});

Nifty.panels['Entity12'] = {
	subtitle: 'Product',
	title: 'Loading',
	newItemTitle: 'New Product',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-12',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			defaults: {autoScroll:false},
			items: [
				{xtype: 'panel',
				 layout: 'niftyForm',
				 title: 'Information',
				 items: [{xtype: 'Field15'},{xtype: 'Field16'},{xtype: 'Field17'},{xtype: 'Field18'}]
				}
			]
	}
};

Nifty.panels['Entity12side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};
