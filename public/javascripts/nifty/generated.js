
Nifty.pages.home = function(){
	return new Nifty.Page({
	mainPanel: new Nifty.widgets.MainPanel({
		title: 'Home',
		subtitle: 'Welcome, Shlomi Atar',
		iconCls: 'x-house-icon',
		items: {
			xtype: 'panel',
			html: '<br><br><a href="#/entities/273">Shlomi Atar</a><br><br><a href="#/entities/274">Macbook Pro</a>'
		},
		renderTo: 'main'
		
	}),

	sidePanel: new Ext.Panel({
		title: 'Side',
		renderTo: 'side'
	})
});}


Nifty.pages.Page2 = function(){
	return new Nifty.Page({
	mainPanel: new Nifty.widgets.MainPanel({
		title: 'Inbox',
		subtitle: '0 messages',
		renderTo: 'main'
	}),

	sidePanel: new Ext.Panel({
		title: 'InboxItems',
		renderTo: 'side'
	})
});}

Nifty.panels['Entity2'] = {
	subtitle: 'People',
	title: 'Loading',
	renderTo: 'main',
	iconCls: 'x-person-icon',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			defaults: {autoScroll:false},
			items: [
				{xtype: 'panel', 
				 title: 'Information',
				 items: [
					{xtype: 'Field5'},
					{xtype: 'Field6'}
					]
				},
				{xtype: 'panel', 
				 title: 'Extra',
				 items: [
					{xtype: 'Field6'}
					]
				}
			]
	}
};


Nifty.panels['Entity2side'] = {
	title: 'Side Panel',
	renderTo: 'side'
};

Nifty.panels['Entity3'] = {
	subtitle: 'Products',
	title: 'Loading',
	renderTo: 'main',
	iconCls: 'x-product-icon',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			items: [
				{xtype: 'panel', 
				 title: 'Information',
				 items: [
					{xtype: 'Field1'},
					{xtype: 'Field2'},
					{xtype: 'Field3'},
					{xtype: 'Field4'},
					]
				}
			]
	}};


Nifty.panels['Entity3side'] = {
	title: 'Products Panels',
	renderTo: 'side'
};

Nifty.fieldlets = {};



Nifty.fieldlets.Fieldlet1 = Ext.extend(Ext.form.TextField, {
	id: 'entity[1]'
})

Ext.reg('Fieldlet1', Nifty.fieldlets.Fieldlet1);


Nifty.fieldlets.Fieldlet2 = Ext.extend(Ext.form.TextField, {
	id: 'entity[2]'
})

Ext.reg('Fieldlet2', Nifty.fieldlets.Fieldlet2);


Nifty.fieldlets.Fieldlet3 = Ext.extend(Ext.form.TextField, {
	id: 'entity[3]'
})

Ext.reg('Fieldlet3', Nifty.fieldlets.Fieldlet3);


Nifty.fieldlets.Fieldlet4 = Ext.extend(Ext.form.TextField, {
	id: 'entity[4]'
})

Ext.reg('Fieldlet4', Nifty.fieldlets.Fieldlet4);








Nifty.fieldlets.Fieldlet5 = Ext.extend(Ext.form.TextField, {
	fieldLabel: 'Last',
	emptyText: 'First',
	allowBlank: false,
	id: 'entity[5]'
})

Ext.reg('Fieldlet5', Nifty.fieldlets.Fieldlet5);

Nifty.fieldlets.Fieldlet6 = Ext.extend(Ext.form.TextField, {
	emptyText: 'Middle',
	id: 'entity[6]'
})
Ext.reg('Fieldlet6', Nifty.fieldlets.Fieldlet6);

Nifty.fieldlets.Fieldlet7 = Ext.extend(Ext.form.TextField, {
	fieldLabel: 'Last',
	emptyText: 'Last',
 	allowBlank: false,
	id: 'entity[7]'
})

Ext.reg('Fieldlet7', Nifty.fieldlets.Fieldlet7);

Nifty.fieldlets.Fieldlet8 = Ext.extend(Ext.form.TextField, {
	fieldLabel: 'Last',
	id: 'entity[8]'
})

Ext.reg('Fieldlet8', Nifty.fieldlets.Fieldlet8);

Nifty.fieldlets.Fieldlet9 = Ext.extend(Ext.form.TextField, {
	fieldLabel: 'Last',
	id: 'entity[9]'
})

Ext.reg('Fieldlet9', Nifty.fieldlets.Fieldlet9);



Nifty.fields = {};


Nifty.fields.field1 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: 1,
	title: 'Product Name',
	fieldlets: [
		{xtype: 'Fieldlet1'}
	]
})

Ext.reg('Field1', Nifty.fields.field1);

Nifty.fields.field2 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: 2,
	title: 'SN',
	fieldlets: [
		{xtype: 'Fieldlet2'}
	]
})

Ext.reg('Field2', Nifty.fields.field2);

Nifty.fields.field3 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: 3,
	title: 'Price',
	fieldlets: [
		{xtype: 'Fieldlet3'}
	]
})

Ext.reg('Field3', Nifty.fields.field3);

Nifty.fields.field4 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: 4,
	title: 'Stock Quantity',
	fieldlets: [
		{xtype: 'Fieldlet4'}
	]
})

Ext.reg('Field4', Nifty.fields.field4);

Nifty.fields.field5 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: 5,
	title: 'Full Name',
	fieldlets: [
		{xtype: 'Fieldlet5'},
		{xtype: 'Fieldlet6'},
		{xtype: 'Fieldlet7'},
	]
})

Ext.reg('Field5', Nifty.fields.field5);

Nifty.fields.field6 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: 6,
	title: 'Contact Information',
	fieldlets: [
		{xtype: 'Fieldlet8'},
		{xtype: 'Fieldlet9'}
	]
})

Ext.reg('Field6', Nifty.fields.field6);




