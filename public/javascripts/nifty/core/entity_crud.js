/*
* EntityCRUD
*
*
*/ 


Nifty.data.EntityCRUD = function(config){
	// apply config
	Ext.apply(this,config);
}


Nifty.data.EntityCRUD.prototype =  {
	read: function(entity_id, options){	
		 // Ajax Request
		 Ext.Ajax.request({
		        url: String.format('{0}/entities/{1}.js', this.namespace, entity_id),
		        success: options.onSuccess,
		 	   	failure: options.onFailure,
		        method: 'get',
		 	   	scope: options.scope
		      });
	},
	
	create: function(jsonData, options){
	  // Ajax Request
	  Ext.Ajax.request({
	        url: String.format('{0}/entities.js', this.namespace),
	        success: options.onSuccess,
	  	   	failure: options.onFailure,
	        method: 'post',
	  	   	scope: options.scope,
			jsonData: {entity: jsonData}
	       });	
	},
	
	
	update: function(entity_id, jsonData, options){
	  // Ajax Request
	  Ext.Ajax.request({
	        url: String.format('{0}/entities/{1}.js', this.namespace, entity_id),
	        success: options.onSuccess,
	  	   	failure: options.onFailure,
	        method: 'put',
	  	   	scope: options.scope,
			jsonData: {entity: jsonData}
	       });
	},
	
	destroy: function(entity_id, options){
	  // Ajax Request
	  Ext.Ajax.request({
         	url: String.format('{0}/entities/{1}.js', this.namespace, entity_id),
	        success: options.onSuccess,
	  	   	failure: options.onFailure,
	        method: 'delete',
	  	   	scope: options.scope
	       });	
	},
};