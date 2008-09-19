/*
* FieldStore.
*
*
*/


Nifty.data.FieldStore = function(options){
	Nifty.data.FieldStore.superclass.constructor.call(this, Ext.apply(options, {
		reader: new Nifty.data.simpleReader({fields: options.fieldlets}),
		proxy: new Nifty.data.entityStoreProxy({fieldId: options.storeId}),
		autoLoad: true
	}));
};

Ext.extend(Nifty.data.FieldStore, Ext.data.Store, {});