/*
* FieldStore.
*
*
*/


Nifty.data.FieldStore = function(options){
	options.fields = ['instance_id'].concat(options.fieldlets);
	
	Nifty.data.FieldStore.superclass.constructor.call(this, Ext.apply(options, {
		reader: new Nifty.data.simpleReader({fields: options.fields}),
		proxy: new Nifty.data.entityStoreProxy({fieldId: options.storeId}),
		autoLoad: true
	}));
};

Ext.extend(Nifty.data.FieldStore, Ext.data.Store, {});