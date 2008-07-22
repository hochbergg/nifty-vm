Nifty.fieldlets.Fieldlet102 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Name'}
});
Ext.reg('Fieldlet102', Nifty.fieldlets.Fieldlet102);

Nifty.fieldlets.Fieldlet103 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Serial Number'}
});
Ext.reg('Fieldlet103', Nifty.fieldlets.Fieldlet103);

Nifty.fieldlets.Fieldlet104 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Price'}
});
Ext.reg('Fieldlet104', Nifty.fieldlets.Fieldlet104);

Nifty.fieldlets.Fieldlet105 = Ext.extend(Nifty.widgets.fieldlets.LinkFieldlet, {
	editItemOptions: {emptyText: 'Favorited By Customers'}
});
Ext.reg('Fieldlet105', Nifty.fieldlets.Fieldlet105);

Nifty.fieldlets.Fieldlet106 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'First Name'}
});
Ext.reg('Fieldlet106', Nifty.fieldlets.Fieldlet106);

Nifty.fieldlets.Fieldlet107 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Middle Name'}
});
Ext.reg('Fieldlet107', Nifty.fieldlets.Fieldlet107);

Nifty.fieldlets.Fieldlet108 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Last Name'}
});
Ext.reg('Fieldlet108', Nifty.fieldlets.Fieldlet108);

Nifty.fieldlets.Fieldlet109 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Type'}
});
Ext.reg('Fieldlet109', Nifty.fieldlets.Fieldlet109);

Nifty.fieldlets.Fieldlet110 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Contact'}
});
Ext.reg('Fieldlet110', Nifty.fieldlets.Fieldlet110);

Nifty.fieldlets.Fieldlet111 = Ext.extend(Nifty.widgets.fieldlets.LinkFieldlet, {
	editItemOptions: {emptyText: 'Favorite Products'}
});
Ext.reg('Fieldlet111', Nifty.fieldlets.Fieldlet111);

Nifty.fields.field75 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '75',
	fieldLabel: 'Name',
	fieldlets: [{kind: 102}]
})
Ext.reg('Field75', Nifty.fields.field75);			

Nifty.fields.field76 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '76',
	fieldLabel: 'Serial Number',
	fieldlets: [{kind: 103}]
})
Ext.reg('Field76', Nifty.fields.field76);			

Nifty.fields.field77 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '77',
	fieldLabel: 'Price',
	fieldlets: [{kind: 104}]
})
Ext.reg('Field77', Nifty.fields.field77);			

Nifty.fields.field78 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '78',
	fieldLabel: 'Favorited By Customers',
	fieldlets: [{kind: 105}]
})
Ext.reg('Field78', Nifty.fields.field78);			

Nifty.fields.field79 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '79',
	fieldLabel: 'Name',
	fieldlets: [{kind: 106},{kind: 107},{kind: 108}]
})
Ext.reg('Field79', Nifty.fields.field79);			

Nifty.fields.field80 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '80',
	fieldLabel: 'Contacts',
	fieldlets: [{kind: 109},{kind: 110}]
})
Ext.reg('Field80', Nifty.fields.field80);			

Nifty.fields.field81 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '81',
	fieldLabel: 'Favorite Products',
	fieldlets: [{kind: 111}]
})
Ext.reg('Field81', Nifty.fields.field81);			

Nifty.entities.kinds.push({id: 51, singleName: 'Order', multiName: 'Order'});

Nifty.panels['Entity51'] = {
	subtitle: 'Order',
	title: 'Loading',
	newItemTitle: 'New Order',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-51',
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

Nifty.panels['Entity51side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.entities.kinds.push({id: 52, singleName: 'Customer', multiName: 'Customer'});

Nifty.panels['Entity52'] = {
	subtitle: 'Customer',
	title: 'Loading',
	newItemTitle: 'New Customer',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-52',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			defaults: {autoScroll:false},
			items: [
				{xtype: 'panel',
				 layout: 'niftyForm',
				 title: 'Information',
				 items: [{xtype: 'Field79'},{xtype: 'Field80'},{xtype: 'Field81'}]
				}
			]
	}
};

Nifty.panels['Entity52side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.entities.kinds.push({id: 53, singleName: 'Product', multiName: 'Product'});

Nifty.panels['Entity53'] = {
	subtitle: 'Product',
	title: 'Loading',
	newItemTitle: 'New Product',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-53',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			defaults: {autoScroll:false},
			items: [
				{xtype: 'panel',
				 layout: 'niftyForm',
				 title: 'Information',
				 items: [{xtype: 'Field75'},{xtype: 'Field76'},{xtype: 'Field77'},{xtype: 'Field78'}]
				}
			]
	}
};

Nifty.panels['Entity53side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};
