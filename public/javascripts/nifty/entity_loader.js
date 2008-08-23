
Nifty.entityLoader = function(){	
	
	return {
		load: function(id){
			this.setLoading();
			var store = this.getStore();
			store.on('load', this.finishLoading, this); //evented loading
			store.load({id: id});
		},
		
		create: function(entity_kind){
			var klass = Nifty.schema.loaded.prepareAndRegister(entity_kind);
			new klass({isCreate: true, entityStore: this.getStore()});
		},
		
		getStore: function(){
			return new Nifty.data.EntityStore();
		},
		
		setLoading: function(){
			Nifty.widgets.page.prototype.showLoading();
		},
		
		finishLoading: function(store, data, options){
			var klass = Nifty.schema.loaded.prepareAndRegister(data.type);
			new klass({entityStore: store});
		}
	}
}();