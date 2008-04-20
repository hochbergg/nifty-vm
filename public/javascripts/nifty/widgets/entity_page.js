/*
* Nifty.EntityPage
*
* A page which loads the side and main panel by the returned entity from server
*
*/


Nifty.EntityPage = function(options){
	Ext.apply(this,options, {})
	
	this.addEvents({
		'beforeRender': true,
		'rendered': true
	})
	
	this.entityStore = new Nifty.data.EntityStore();
	this.entityStore.on('beforeload', 	 this.mask);
	this.entityStore.on('loadexception', this.error);
	this.entityStore.on('load', this.render); //evented loading
}


Ext.extend(Nifty.EntityPage, Ext.util.Observable,{
	
	load: function(entity_id){		
		this.entityStore.load({'id': entity_id})
	},
	
	render: function(entityStore, data, entityStoreOptions){
		Ext.fly('page_loading').setDisplayed(true)
		Ext.fly('main').setDisplayed(false)
		Ext.fly('side').setDisplayed(false)
		
		// clear
		if (Nifty.pages.current){
			var current = Nifty.pages.current;
			if(current.mainPanel)
				current.mainPanel.destroy();
			
			if(current.sidePanel)	
				current.sidePanel.destroy();
		}
		
		
		// Load panels from hash
		// set the entity store for the panels
		// render!
		
		if ( mainPanel = Nifty.panels[data.type]){
			mainPanel.entityStore = entityStore;
			this.mainPanel = new Nifty.widgets.EntityPanel(mainPanel);
			this.mainPanel.render();
		} else {
			this.mainPanel =  null;
		}
		
		if (sidePanel = Nifty.panels[data.type + 'side']){
			sidePanel.entityStore = entityStore;
			this.sidePanel = new Ext.Panel(sidePanel);
			this.mainPanel.render();
		} else {
			this.sidePanel = null;
		}
		
		
		Ext.fly('page_loading').setDisplayed(false)
		Ext.fly('main').setDisplayed(true)
		Ext.fly('side').setDisplayed(true)
		Nifty.pages.current = this;
	},
	
	mask: function(){
		//alert('loading');
	},
	
	error: function(){
		alert('error!');
	},
	
	mainPanel: null,
	sidePanel: null
});


Nifty.pages.EntityPage = new Nifty.EntityPage();
