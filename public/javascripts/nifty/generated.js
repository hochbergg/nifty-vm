Nifty.entities = {};
Nifty.entities.actions = {};

Nifty.entities.kinds = [
	{id: 2, singleName: 'Person', multiName: 'People'},
	{id: 3, singleName: 'Product', multiName: 'Products'},
];

Nifty.entities.actions.new = function(){
	var actions = [];
	
	Ext.each(Nifty.entities.kinds, function(kind){
		actions.push({
			text: kind.singleName,
			iconCls: 'small-entity' + kind.id,
			handler: function(){
				Nifty.Router.go('#/entities/new/' + kind.id);
			}
		})
	});
	
	return actions;
}();

Nifty.entities.newEntityButton = {
	xtype: 'button', 
	text: 'Create New',
	menu: {
		xtype: 'menu',
		items: 	Nifty.entities.actions.new
	}
}


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
	newItemTitle: 'New person',
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
					{xtype: 'fieldset1'}
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
	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.panels['Entity3'] = {
	subtitle: 'Products',
	newItemTitle: 'New product',
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
	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};

Nifty.fieldlets = {};



Nifty.fieldlets.Fieldlet1 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
})

Ext.reg('Fieldlet1', Nifty.fieldlets.Fieldlet1);


Nifty.fieldlets.Fieldlet2 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
})

Ext.reg('Fieldlet2', Nifty.fieldlets.Fieldlet2);


Nifty.fieldlets.Fieldlet3 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
})

Ext.reg('Fieldlet3', Nifty.fieldlets.Fieldlet3);


Nifty.fieldlets.Fieldlet4 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
})

Ext.reg('Fieldlet4', Nifty.fieldlets.Fieldlet4);

Nifty.fieldlets.Fieldlet5 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {
		allowBlank: false,
		emptyText: 'First'
	}
})

Ext.reg('Fieldlet5', Nifty.fieldlets.Fieldlet5);

Nifty.fieldlets.Fieldlet6 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {
		allowBlank: true,
		emptyText: 'Middle'
	}
})
Ext.reg('Fieldlet6', Nifty.fieldlets.Fieldlet6);

Nifty.fieldlets.Fieldlet7 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {
		allowBlank: false,
		emptyText: 'Last'
	}
})

Ext.reg('Fieldlet7', Nifty.fieldlets.Fieldlet7);

Nifty.fieldlets.Fieldlet8 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {
		allowBlank: false,
		emptyText: 'Type'
	}
})

Ext.reg('Fieldlet8', Nifty.fieldlets.Fieldlet8);

Nifty.fieldlets.Fieldlet9 = Ext.extend(Nifty.widgets.fieldlets.StringFieldlet, {
	editItemOptions: {
		allowBlank: false,
		emptyText: 'Info'
	}
})

Ext.reg('Fieldlet9', Nifty.fieldlets.Fieldlet9);



Nifty.fields = {};


Nifty.fields.field1 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: 1,
	title: 'Product Name',
	fieldlets: [
		{kind: 1}
	]
})

Ext.reg('Field1', Nifty.fields.field1);

Nifty.fields.field2 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: 2,
	title: 'SN',
	fieldlets: [
		{kind: 2}
	]
})

Ext.reg('Field2', Nifty.fields.field2);

Nifty.fields.field3 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: 3,
	title: 'Price',
	fieldlets: [
		{kind: 3}
	]
})

Ext.reg('Field3', Nifty.fields.field3);

Nifty.fields.field4 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: 4,
	title: 'Stock Quantity',
	fieldlets: [
		{kind: 4}
	]
})

Ext.reg('Field4', Nifty.fields.field4);

Nifty.fields.field5 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: 5,
	title: 'Full Name',
	fieldlets: [
		{kind: 5},
		{kind: 6},
		{kind: 7},
	]
})

Ext.reg('Field5', Nifty.fields.field5);

Nifty.fields.field6 = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: 6,
	title: 'Contact Information',
	fieldlets: [
		{kind: 8},
		{kind: 9}
	]
})

Ext.reg('Field6', Nifty.fields.field6);

Nifty.fields.fieldset1 = Ext.extend(Nifty.widgets.FieldPanel, {
	title: 'Some Fun',
	collapsible: true,
	initComponent: function(){
		Ext.apply(this, {items: [
			{xtype: 'Field6'}
		]});
		
		Nifty.fields.fieldset1.superclass.initComponent.apply(this, arguments);
	}
	
})

Ext.reg('fieldset1', Nifty.fields.fieldset1);