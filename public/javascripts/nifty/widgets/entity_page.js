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
	
	
	load: function(entityId){
		this.isCreate = false;
		this.createId = null;
		this.entityStore.load({'id': entityId})
	},
	
	create: function(entityKindId){
		this.showLoading();
		this.isCreate = true;
		this.createId = entityKindId;
		
		this.entityStore.setNew(entityKindId);
		this.render(this.entityStore, this.entityStore.data)
	},
	

	render: function(entityStore, data, entityStoreOptions){
		this.clear();
		this.setupForm(this.isCreate);
		this.setTitle(data);
		
		// Load panels from hash
		// set the entity store for the panels
		// render!
		
		if (mainPanel = Nifty.panels[data.type]){
			mainPanel.entityStore = this.entityStore;
			mainPanel.tools = [{
				id: 'save',
				handler: function(event, toolEl, panel){
					Nifty.pages.current.submit();
				}}];
			this.mainPanel = new Nifty.widgets.EntityPanel(mainPanel);
			this.mainPanel.render();
		} else {
			this.mainPanel =  null;
		}
		
		if (sidePanel = Nifty.panels[data.type + 'side']){
			sidePanel.entityStore = this.entityStore;
			this.sidePanel = new Ext.Panel(sidePanel);
			this.mainPanel.render();
		} else {
			this.sidePanel = null;
		}
		
		this.hideLoading();
	},
	
	setupForm: function(create){		
		if(create){
			formOptionHash = {
				url: '/entities.js',
				method: 'post',
				baseParams: {
					id: this.createId
				}
			};
						
		} else {
			formOptionHash = {
				url: String.format('/entities/{0}.js', this.entityStore.data.id),
				method: 'put'
			};
		}
		
		
		this.form = new Ext.form.BasicForm('form', formOptionHash);
		
		
		this.form.on('actioncomplete', this.formSuccess, this);
		this.form.on('actionfailed', this.formFailed, this);
	},
	
	setTitle: function(data){
		document.title = String.format("{0}: {1}", 
			Nifty.panels[data.type].subtitle,
			data.display
		);
	},
	
	
	// a callback for a successful form submission
	formSuccess: function(form, action){
		alert('success');
		
		if(action.result.redirect){
			Nifty.Router.go(action.result.redirect);
		}
	},
	
	// a callback for failed form submission
	formFailed: function(form, action){
		alert(action.failureType);
	},
	
	submit: function(){
		this.form.submit();
	},
		
	error: function(){
		alert('error!');
	},
	
	checkDirtyAndOrValidBeforeLeave: function(){
		if (this.form.isDirty()){
			console.log('dirty!')
		}
		
	},
	
	
	beforeLeave: function(){
		return this.checkDirtyAndOrValidBeforeLeave();
	}
	
});


Nifty.pages.EntityPage = new Nifty.EntityPage();
