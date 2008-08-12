Nifty.fieldlets.Fieldlet13 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Name'}
});
Ext.reg('Fieldlet13', Nifty.fieldlets.Fieldlet13);

Nifty.fieldlets.Fieldlet14 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Serial Number'}
});
Ext.reg('Fieldlet14', Nifty.fieldlets.Fieldlet14);

Nifty.fieldlets.Fieldlet15 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Price'}
});
Ext.reg('Fieldlet15', Nifty.fieldlets.Fieldlet15);

Nifty.fieldlets.Fieldlet16 = Ext.extend(Nifty.widgets.fieldlets.LinkFieldlet, {
	editItemOptions: {emptyText: 'Favorited By Customers'}
});
Ext.reg('Fieldlet16', Nifty.fieldlets.Fieldlet16);

Nifty.fieldlets.Fieldlet17 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Bought at'}
});
Ext.reg('Fieldlet17', Nifty.fieldlets.Fieldlet17);

Nifty.fieldlets.Fieldlet18 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'First Name'}
});
Ext.reg('Fieldlet18', Nifty.fieldlets.Fieldlet18);

Nifty.fieldlets.Fieldlet19 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Middle Name'}
});
Ext.reg('Fieldlet19', Nifty.fieldlets.Fieldlet19);

Nifty.fieldlets.Fieldlet20 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Last Name'}
});
Ext.reg('Fieldlet20', Nifty.fieldlets.Fieldlet20);

Nifty.fieldlets.Fieldlet21 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Type'}
});
Ext.reg('Fieldlet21', Nifty.fieldlets.Fieldlet21);

Nifty.fieldlets.Fieldlet22 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Contact'}
});
Ext.reg('Fieldlet22', Nifty.fieldlets.Fieldlet22);

Nifty.fieldlets.Fieldlet23 = Ext.extend(Nifty.widgets.fieldlets.LinkFieldlet, {
	editItemOptions: {emptyText: 'Favorite Products'}
});
Ext.reg('Fieldlet23', Nifty.fieldlets.Fieldlet23);

Nifty.fieldlets.Fieldlet24 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Bought at'}
});
Ext.reg('Fieldlet24', Nifty.fieldlets.Fieldlet24);

Nifty.fields.field8 = Ext.extend(Nifty.widgets.FieldContainer, {
	fieldId: '8',
	fieldLabel: 'Name',
	
	instanceLayout: [{kind: 13}]
	
})
Ext.reg('Field8', Nifty.fields.field8);			

Nifty.fields.field9 = Ext.extend(Nifty.widgets.FieldContainer, {
	fieldId: '9',
	fieldLabel: 'Serial Number',
	
	instanceLayout: [{kind: 14}]
	
})
Ext.reg('Field9', Nifty.fields.field9);			

Nifty.fields.field10 = Ext.extend(Nifty.widgets.FieldContainer, {
	fieldId: '10',
	fieldLabel: 'Price',
	
	instanceLayout: [{kind: 15}]
	
})
Ext.reg('Field10', Nifty.fields.field10);			

Nifty.fields.field11 = Ext.extend(Nifty.widgets.FieldContainer, {
	fieldId: '11',
	fieldLabel: 'Favorited By Customers',
	
	instanceLayout: [{kind: 16},{kind: 17}]
	
})
Ext.reg('Field11', Nifty.fields.field11);			

Nifty.fields.field12 = Ext.extend(Nifty.widgets.FieldContainer, {
	fieldId: '12',
	fieldLabel: 'Name',
	
	instanceLayout: [{kind: 18},{kind: 19},{kind: 20}]
	
})
Ext.reg('Field12', Nifty.fields.field12);			

Nifty.fields.field13 = Ext.extend(Nifty.widgets.FieldContainer, {
	fieldId: '13',
	fieldLabel: 'Contacts',
	
	instanceLayout: [{kind: 21},{kind: 22}]
	
})
Ext.reg('Field13', Nifty.fields.field13);			

Nifty.fields.field14 = Ext.extend(Nifty.widgets.FieldContainer, {
	fieldId: '14',
	fieldLabel: 'Favorite Products',
	
	instanceLayout: [{kind: 23},{kind: 24}]
	
})
Ext.reg('Field14', Nifty.fields.field14);			

Nifty.entities.kinds.push({id: 7, singleName: 'Order', multiName: 'Order'});

Nifty.panels['Entity7'] = {
	subtitle: 'Order',
	title: 'Loading',
	newItemTitle: 'New Order',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-7',
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

Nifty.panels['Entity7side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.entities.kinds.push({id: 8, singleName: 'Customer', multiName: 'Customer'});

Nifty.panels['Entity8'] = {
	subtitle: 'Customer',
	title: 'Loading',
	newItemTitle: 'New Customer',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-8',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			defaults: {autoScroll:false},
			items: [
				{xtype: 'panel',
				 layout: 'niftyForm',
				 title: 'Information',
				 items: [{xtype: 'Field12'},{xtype: 'Field13'},{xtype: 'Field14'}]
				}
			]
	}
};

Nifty.panels['Entity8side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.entities.kinds.push({id: 9, singleName: 'Product', multiName: 'Product'});

Nifty.panels['Entity9'] = {
	subtitle: 'Product',
	title: 'Loading',
	newItemTitle: 'New Product',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-9',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			defaults: {autoScroll:false},
			items: [
				{xtype: 'panel',
				 layout: 'niftyForm',
				 title: 'Information',
				 items: [{xtype: 'Field8'},{xtype: 'Field9'},{xtype: 'Field10'},{xtype: 'Field11'}]
				}
			]
	}
};

Nifty.panels['Entity9side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};
