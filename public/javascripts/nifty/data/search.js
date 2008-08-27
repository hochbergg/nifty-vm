

Nifty.data.SearchStore = new Ext.data.JsonStore({
    url: '/entities/search.js',
    root: 'entities',
    totalProperty: 'total',
	id: 'id',	
    fields: ['id', 'display', 'type']
});