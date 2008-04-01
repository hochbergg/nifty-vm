/*
* Nifty Data Classes. 
* Includes entity data stores
*/


/* Loader */


// loads entity with the given value
Nifty.Data.Entity = function(){
	
	var loadFieldlets = function(){
		current.fieldlets = Nifty.Data.Fieldlet.getReader().readRecords(current.fieldlets)
	}
	
	var current = null
	
	return {
		
		load: function(entity_id){
			result = Ext.Ajax.request({
			   url: '/entities/' + entity_id + '.js',
			   success: this.init.call(this),
			   method: 'get'
			});
		},
		
		init: function(response){
			this.current = (Ext.util.JSON.decode(response.responseText))
			loadFieldlets();
		}
		
	}
}();
