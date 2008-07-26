Nifty.fieldlets.Fieldlet112 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Name'}
});
Ext.reg('Fieldlet112', Nifty.fieldlets.Fieldlet112);

Nifty.fieldlets.Fieldlet113 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Serial Number'}
});
Ext.reg('Fieldlet113', Nifty.fieldlets.Fieldlet113);

Nifty.fieldlets.Fieldlet114 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Price'}
});
Ext.reg('Fieldlet114', Nifty.fieldlets.Fieldlet114);

Nifty.fieldlets.Fieldlet115 = Ext.extend(Nifty.widgets.fieldlets.LinkFieldlet, {
	editItemOptions: {emptyText: 'Favorited By Customers'}
});
Ext.reg('Fieldlet115', Nifty.fieldlets.Fieldlet115);

Nifty.fieldlets.Fieldlet116 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Bought at'}
});
Ext.reg('Fieldlet116', Nifty.fieldlets.Fieldlet116);

Nifty.fieldlets.Fieldlet117 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'First Name'}
});
Ext.reg('Fieldlet117', Nifty.fieldlets.Fieldlet117);

Nifty.fieldlets.Fieldlet118 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Middle Name'}
});
Ext.reg('Fieldlet118', Nifty.fieldlets.Fieldlet118);

Nifty.fieldlets.Fieldlet119 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Last Name'}
});
Ext.reg('Fieldlet119', Nifty.fieldlets.Fieldlet119);

Nifty.fieldlets.Fieldlet120 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Type'}
});
Ext.reg('Fieldlet120', Nifty.fieldlets.Fieldlet120);

Nifty.fieldlets.Fieldlet121 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Contact'}
});
Ext.reg('Fieldlet121', Nifty.fieldlets.Fieldlet121);

Nifty.fieldlets.Fieldlet122 = Ext.extend(Nifty.widgets.fieldlets.LinkFieldlet, {
	editItemOptions: {emptyText: 'Favorite Products'}
});
Ext.reg('Fieldlet122', Nifty.fieldlets.Fieldlet122);

Nifty.fieldlets.Fieldlet123 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Bought at'}
});
Ext.reg('Fieldlet123', Nifty.fieldlets.Fieldlet123);

Nifty.fields.field82 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '82',
	fieldLabel: 'Name',
	fieldlets: [{kind: 112}]
})
Ext.reg('Field82', Nifty.fields.field82);			

Nifty.fields.field83 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '83',
	fieldLabel: 'Serial Number',
	fieldlets: [{kind: 113}]
})
Ext.reg('Field83', Nifty.fields.field83);			

Nifty.fields.field84 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '84',
	fieldLabel: 'Price',
	fieldlets: [{kind: 114}]
})
Ext.reg('Field84', Nifty.fields.field84);			

Nifty.fields.field85 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '85',
	fieldLabel: 'Favorited By Customers',
	fieldlets: [{kind: 115},{kind: 116}]
})
Ext.reg('Field85', Nifty.fields.field85);			

Nifty.fields.field86 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '86',
	fieldLabel: 'Name',
	fieldlets: [{kind: 117},{kind: 118},{kind: 119}]
})
Ext.reg('Field86', Nifty.fields.field86);			

Nifty.fields.field87 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '87',
	fieldLabel: 'Contacts',
	fieldlets: [{kind: 120},{kind: 121}]
})
Ext.reg('Field87', Nifty.fields.field87);			

Nifty.fields.field88 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '88',
	fieldLabel: 'Favorite Products',
	fieldlets: [{kind: 122},{kind: 123}]
})
Ext.reg('Field88', Nifty.fields.field88);			

Nifty.entities.kinds.push({id: 54, singleName: 'Order', multiName: 'Order'});

Nifty.panels['Entity54'] = {
	subtitle: 'Order',
	title: 'Loading',
	newItemTitle: 'New Order',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-54',
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

Nifty.panels['Entity54side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.entities.kinds.push({id: 55, singleName: 'Customer', multiName: 'Customer'});

Nifty.panels['Entity55'] = {
	subtitle: 'Customer',
	title: 'Loading',
	newItemTitle: 'New Customer',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-55',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			defaults: {autoScroll:false},
			items: [
				{xtype: 'panel',
				 layout: 'niftyForm',
				 title: 'Information',
				 items: [{xtype: 'Field86'},{xtype: 'Field87'},{xtype: 'Field88'}]
				}
			]
	}
};

Nifty.panels['Entity55side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.entities.kinds.push({id: 56, singleName: 'Product', multiName: 'Product'});

Nifty.panels['Entity56'] = {
	subtitle: 'Product',
	title: 'Loading',
	newItemTitle: 'New Product',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-56',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			defaults: {autoScroll:false},
			items: [
				{xtype: 'panel',
				 layout: 'niftyForm',
				 title: 'Information',
				 items: [{xtype: 'Field82'},{xtype: 'Field83'},{xtype: 'Field84'},{xtype: 'Field85'}]
				}
			]
	}
};

Nifty.panels['Entity56side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};
