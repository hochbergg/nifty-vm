/*
* Nifty.EntityPage
*
* A page which loads the side and main panel by the returned entity from server
*
*/


Nifty.widgets.entity = Ext.extend(Nifty.widgets.page,{
	mainComponent: Nifty.widgets.entityPanel,
	
	init: function(){
		// setup default items if no layout is given
		if(this.kids && !this.mainPanel){ // if no layout, create a default one
			this.mainPanel = {items: []};
			Ext.each(this.kids, function(i){
				this.mainPanel.items.push({xtype: i});
			},this);
		};
		
		// setup name
		this.subtitle = this.name;
		this.iconCls = "icon-big-" + this.identifier;
	},
	
	beforeLoad: function(){
		this.clear();
		if(this.isCreate){this.entityStore.setNew(this.identifier)}
		this.setupForm(this.isCreate);
		this.setTitle(this.entityStore.data);
		
		if(!this.sidePanel){
			this.sidePanel = {items: [{xtype: 'newEntityButton'}]};
		}
		
		
		// setup entityStores
		if(this.mainPanel){
			this.mainPanel.entityStore = this.entityStore;	
			this.mainPanel.subtitle = this.subtitle; 
			this.mainPanel.iconCls = this.iconCls; 		
		}
		
		if(this.sidePanel){
			this.sidePanel.entityStore = this.entityStore;			
		}
	},
	
	
	setupForm: function(create){		
		if(create){
			formOptionHash = {
				url: '/entities.js',
				method: 'post',
				baseParams: {
					id: this.identifier
				},
				waitMsgTarget: 'content'
			};
						
		} else {
			formOptionHash = {
				url: String.format('/entities/{0}.js', this.entityStore.data.id),
				method: 'put',
				waitMsgTarget: 'content'
			};
		}
		
		
		this.form = new Ext.form.BasicForm('form', formOptionHash);
		
		
		this.form.on('actioncomplete', this.formSuccess, this);
		this.form.on('actionfailed', this.formFailed, this);
		this.form.on('beforeaction', this.beforeAction, this);
	},
	
	setTitle: function(data){
		var title = data.display ? data.display : (this.isCreate ? ('New ' + this.name) : '(No Title)');
		
		document.title = String.format("{0}: {1}", 
			this.subtitle,
			title
		);
	},
	
	// called before form submission
	// we want to check if we have any items to submit. 
	// if not, we should not submit
	beforeAction: function(form, action){
		if (!form.isDirty()){
			alert('nothing has changed!');
			return false;
		}
		
		// iterate over form items, disable all the not dirty ones
		form.items.each(function(item){
			if(!item.isDirty()){
				item.disable();
			}
		})
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
	//		console.log('dirty!')
		}
	},
	
	
	beforeLeave: function(){
		return this.checkDirtyAndOrValidBeforeLeave();
	}
	
});
	
	

//	render: function(entityStore, data, entityStoreOptions){
//		this.clear();
//		this.setupForm(this.isCreate);
//		this.setTitle(data);
//		
//		// Load panels from hash
//		// set the entity store for the panels
//		// render!
//		
//		if (mainPanel = Nifty.panels[data.type]){
//			mainPanel.entityStore = this.entityStore;
//			mainPanel.tools = [{
//				id: 'save',
//				handler: function(event, toolEl, panel){
//					Nifty.pages.current.submit();
//				}}];
//			this.mainPanel = new Nifty.widgets.EntityPanel(mainPanel);
//			this.mainPanel.render();
//		} else {
//			this.mainPanel =  null;
//		}
//		
//		if (sidePanel = Nifty.panels[data.type + 'side']){
//			sidePanel.entityStore = this.entityStore;
//			this.sidePanel = new Ext.Panel(sidePanel);
//			this.mainPanel.render();
//		} else {
//			this.sidePanel = null;
//		}
//		
//		this.hideLoading();
//	},
	
