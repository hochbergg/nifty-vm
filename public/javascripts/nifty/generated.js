Nifty.fieldlets.Fieldlet82 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Name'}
});
Ext.reg('Fieldlet82', Nifty.fieldlets.Fieldlet82);

Nifty.fieldlets.Fieldlet83 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Serial Number'}
});
Ext.reg('Fieldlet83', Nifty.fieldlets.Fieldlet83);

Nifty.fieldlets.Fieldlet84 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Price'}
});
Ext.reg('Fieldlet84', Nifty.fieldlets.Fieldlet84);

Nifty.fieldlets.Fieldlet85 = Ext.extend(Nifty.widgets.fieldlets.LinkFieldlet, {
	editItemOptions: {emptyText: 'Favorited By Customers'}
});
Ext.reg('Fieldlet85', Nifty.fieldlets.Fieldlet85);

Nifty.fieldlets.Fieldlet86 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'First Name'}
});
Ext.reg('Fieldlet86', Nifty.fieldlets.Fieldlet86);

Nifty.fieldlets.Fieldlet87 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Middle Name'}
});
Ext.reg('Fieldlet87', Nifty.fieldlets.Fieldlet87);

Nifty.fieldlets.Fieldlet88 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Last Name'}
});
Ext.reg('Fieldlet88', Nifty.fieldlets.Fieldlet88);

Nifty.fieldlets.Fieldlet89 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Type'}
});
Ext.reg('Fieldlet89', Nifty.fieldlets.Fieldlet89);

Nifty.fieldlets.Fieldlet90 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {emptyText: 'Contact'}
});
Ext.reg('Fieldlet90', Nifty.fieldlets.Fieldlet90);

Nifty.fieldlets.Fieldlet91 = Ext.extend(Nifty.widgets.fieldlets.LinkFieldlet, {
	editItemOptions: {emptyText: 'Favorite Products'}
});
Ext.reg('Fieldlet91', Nifty.fieldlets.Fieldlet91);

Nifty.fields.field61 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '61',
	fieldLabel: 'Name',
	fieldlets: [{kind: 82}]
})
Ext.reg('Field61', Nifty.fields.field61);			

Nifty.fields.field62 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '62',
	fieldLabel: 'Serial Number',
	fieldlets: [{kind: 83}]
})
Ext.reg('Field62', Nifty.fields.field62);			

Nifty.fields.field63 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '63',
	fieldLabel: 'Price',
	fieldlets: [{kind: 84}]
})
Ext.reg('Field63', Nifty.fields.field63);			

Nifty.fields.field64 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '64',
	fieldLabel: 'Favorited By Customers',
	fieldlets: [{kind: 85}]
})
Ext.reg('Field64', Nifty.fields.field64);			

Nifty.fields.field65 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '65',
	fieldLabel: 'Name',
	fieldlets: [{kind: 86},{kind: 87},{kind: 88}]
})
Ext.reg('Field65', Nifty.fields.field65);			

Nifty.fields.field66 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '66',
	fieldLabel: 'Contacts',
	fieldlets: [{kind: 89},{kind: 90}]
})
Ext.reg('Field66', Nifty.fields.field66);			

Nifty.fields.field67 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '67',
	fieldLabel: 'Favorite Products',
	fieldlets: [{kind: 91}]
})
Ext.reg('Field67', Nifty.fields.field67);			

Nifty.entities.kinds.push({id: 43, singleName: 'SampleEntityKind', multiName: 'SampleEntityKind'});

Nifty.panels['Entity43'] = {
	subtitle: 'SampleEntityKind',
	title: 'Loading',
	newItemTitle: 'New SampleEntityKind',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-43',
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

Nifty.panels['Entity43side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.entities.kinds.push({id: 44, singleName: 'AntherEntityKind', multiName: 'AntherEntityKind'});

Nifty.panels['Entity44'] = {
	subtitle: 'AntherEntityKind',
	title: 'Loading',
	newItemTitle: 'New AntherEntityKind',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-44',
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

Nifty.panels['Entity44side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.entities.kinds.push({id: 45, singleName: 'Order', multiName: 'Order'});

Nifty.panels['Entity45'] = {
	subtitle: 'Order',
	title: 'Loading',
	newItemTitle: 'New Order',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-45',
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

Nifty.panels['Entity45side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.entities.kinds.push({id: 46, singleName: 'Customer', multiName: 'Customer'});

Nifty.panels['Entity46'] = {
	subtitle: 'Customer',
	title: 'Loading',
	newItemTitle: 'New Customer',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-46',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			defaults: {autoScroll:false},
			items: [
				{xtype: 'panel',
				 layout: 'niftyForm',
				 title: 'Information',
				 items: [{xtype: 'Field65'},{xtype: 'Field66'},{xtype: 'Field67'}]
				}
			]
	}
};

Nifty.panels['Entity46side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.entities.kinds.push({id: 47, singleName: 'Product', multiName: 'Product'});

Nifty.panels['Entity47'] = {
	subtitle: 'Product',
	title: 'Loading',
	newItemTitle: 'New Product',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-47',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			defaults: {autoScroll:false},
			items: [
				{xtype: 'panel',
				 layout: 'niftyForm',
				 title: 'Information',
				 items: [{xtype: 'Field61'},{xtype: 'Field62'},{xtype: 'Field63'},{xtype: 'Field64'}]
				}
			]
	}
};

Nifty.panels['Entity47side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};
