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
	this.entityStore.on('beforeload', 	 this.showLoading, this);
	this.entityStore.on('loadexception', this.error, this);
	this.entityStore.on('load', this.render, this); //evented loading
}


Ext.extend(Nifty.EntityPage, Nifty.Page,{
	mainPanel: null,
	sidePanel: null,
	
	
	load: function(entity_id){
		this.entityStore.load({'id': entity_id})
	},
	

	render: function(entityStore, data, entityStoreOptions){
		this.clear();		
		this.setupForm();
		
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
		
		this.hideLoading();
	},
	
	setupForm: function(){
		this.form = new Ext.form.BasicForm('form', {
			url: String.format('/entities/{0}.js', this.entityStore.data.id),
			method: 'put'
		});
		
		this.form.on('actioncomplete', function(){alert('saved!')});
		this.form.on('actionfailed', function(){alert('failed!')});
	},
	
		
	error: function(){
		alert('error!');
	},
	
	checkDirtyAndOrValidBeforeLeave: function(){
		if (!this.form.isValid()){
			alert('Not Valid!');
			return false;
		}
		
		if (this.form.isDirty()){
			alert('Dirty!');
		}
		
	},
	
	
	beforeLeave: function(){
		return this.checkDirtyAndOrValidBeforeLeave();
	}
	
});


Nifty.pages.EntityPage = new Nifty.EntityPage();
