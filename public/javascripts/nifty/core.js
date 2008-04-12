/**
  * Nifty Core Application
  * by Shlomi Atar
  */
 

Ext.namespace('Nifty',
			  'Nifty.data',
			  'Nifty.widgets');



// create application
Nifty.app = function() {
    // do NOT access DOM from here; elements don't exist yet
 	
	
    // private variables
 
    // private functions

	function hideLoaders(){
		 setTimeout(function(){
		    	Ext.get('loading').remove();
		    	Ext.get('loading-mask').fadeOut({remove:true});
		    }, 250);
	}
	
	
	function drawLayout(){
		var ep = new Nifty.widgets.EntityPanel({
			title: 'EntityPanel',
			el: 'main',
			items: {
				xtype: 'tabPanel',
				items: [
					{title: 'Product Information', xtype: 'panel'},
					{title: 'Order History', xtype: 'panel'}
				]
			}
			//tabItems: [
			//	new Ext.Panel({title: 'Product Information'}),
			//	new Ext.Panel({title: 'Order History'})
			//]
		});
		
		
		
		ep.render();
	}

	function prepareEntityStore(){
		var entityStore = new Nifty.data.EntityStore();
		entityStore.on('load',function(){
			alert('loaded!');
		});
		
		return entityStore;
	}
 
    // public space
    return {
        init: function() {
			// Hide Loader
			hideLoaders();
			
			this.entityStore = prepareEntityStore();
			
			drawLayout();
	 	},
	
		loadEntity: function(id){
			this.entityStore.load({id: id});
		}
	}
}(); // end of app
 