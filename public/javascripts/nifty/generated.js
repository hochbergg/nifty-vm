Nifty.fieldlets.Fieldlet1 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Name'}
});
Ext.reg('Fieldlet1', Nifty.fieldlets.Fieldlet1);

Nifty.fieldlets.Fieldlet2 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'SerialNumber'}
});
Ext.reg('Fieldlet2', Nifty.fieldlets.Fieldlet2);

Nifty.fieldlets.Fieldlet3 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Price'}
});
Ext.reg('Fieldlet3', Nifty.fieldlets.Fieldlet3);

Nifty.fieldlets.Fieldlet4 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Quantity'}
});
Ext.reg('Fieldlet4', Nifty.fieldlets.Fieldlet4);

Nifty.fieldlets.Fieldlet5 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'First Name'}
});
Ext.reg('Fieldlet5', Nifty.fieldlets.Fieldlet5);

Nifty.fieldlets.Fieldlet6 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Middle Name'}
});
Ext.reg('Fieldlet6', Nifty.fieldlets.Fieldlet6);

Nifty.fieldlets.Fieldlet7 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Last Name'}
});
Ext.reg('Fieldlet7', Nifty.fieldlets.Fieldlet7);

Nifty.fieldlets.Fieldlet8 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Type'}
});
Ext.reg('Fieldlet8', Nifty.fieldlets.Fieldlet8);

Nifty.fieldlets.Fieldlet9 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Contact'}
});
Ext.reg('Fieldlet9', Nifty.fieldlets.Fieldlet9);

Nifty.fieldlets.Fieldlet10 = Ext.extend(Nifty.widgets.fieldlets.LinkFieldlet, {
	editItemOptions: {emptyText: 'Favorite Products'}
});
Ext.reg('Fieldlet10', Nifty.fieldlets.Fieldlet10);

Nifty.fieldlets.Fieldlet11 = Ext.extend(Nifty.widgets.fieldlets.LinkFieldlet, {
	editItemOptions: {emptyText: 'Favorited By Customers'}
});
Ext.reg('Fieldlet11', Nifty.fieldlets.Fieldlet11);

Nifty.fields.field1 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '1',
	fieldLabel: 'Name',
	fieldlets: [{kind: 1}]
})
Ext.reg('Field1', Nifty.fields.field1);			

Nifty.fields.field2 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '2',
	fieldLabel: 'Serial Number',
	fieldlets: [{kind: 2}]
})
Ext.reg('Field2', Nifty.fields.field2);			

Nifty.fields.field3 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '3',
	fieldLabel: 'Price',
	fieldlets: [{kind: 3}]
})
Ext.reg('Field3', Nifty.fields.field3);			

Nifty.fields.field4 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '4',
	fieldLabel: 'Quantity',
	fieldlets: [{kind: 4}]
})
Ext.reg('Field4', Nifty.fields.field4);			

Nifty.fields.field5 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '5',
	fieldLabel: 'Name',
	fieldlets: [{kind: 5},{kind: 6},{kind: 7}]
})
Ext.reg('Field5', Nifty.fields.field5);			

Nifty.fields.field6 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '6',
	fieldLabel: 'Contacts',
	fieldlets: [{kind: 8},{kind: 9}]
})
Ext.reg('Field6', Nifty.fields.field6);			

Nifty.fields.field7 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '7',
	fieldLabel: 'Favorite Product',
	fieldlets: [{kind: 10}]
})
Ext.reg('Field7', Nifty.fields.field7);			

Nifty.fields.field8 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '8',
	fieldLabel: 'Favorited By Customers',
	fieldlets: [{kind: 11}]
})
Ext.reg('Field8', Nifty.fields.field8);			

Nifty.fields.field10 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '10',
	fieldLabel: 'shlomi',
	fieldlets: []
})
Ext.reg('Field10', Nifty.fields.field10);			

Nifty.entities.kinds.push({id: 1, singleName: 'Order', multiName: 'Order'});

Nifty.panels['Entity1'] = {
	subtitle: 'Order',
	title: 'Loading',
	newItemTitle: 'New Order',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-1',
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

Nifty.panels['Entity1side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.entities.kinds.push({id: 2, singleName: 'Customer', multiName: 'Customer'});

Nifty.panels['Entity2'] = {
	subtitle: 'Customer',
	title: 'Loading',
	newItemTitle: 'New Customer',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-2',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			defaults: {autoScroll:false},
			items: [
				{xtype: 'panel',
				 layout: 'niftyForm',
				 title: 'Information',
				 items: [{xtype: 'Field5'},{xtype: 'Field6'},{xtype: 'Field7'}]
				}
			]
	}
};

Nifty.panels['Entity2side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.entities.kinds.push({id: 3, singleName: 'Product', multiName: 'Product'});

Nifty.panels['Entity3'] = {
	subtitle: 'Product',
	title: 'Loading',
	newItemTitle: 'New Product',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-3',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			defaults: {autoScroll:false},
			items: [
				{xtype: 'panel',
				 layout: 'niftyForm',
				 title: 'Information',
				 items: [{xtype: 'Field1'},{xtype: 'Field2'},{xtype: 'Field3'},{xtype: 'Field4'},{xtype: 'Field8'}]
				}
			]
	}
};

Nifty.panels['Entity3side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};
