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
		if(this.children && !this.mainPanel){ // if no layout, create a default one
			this.mainPanel = {items: []};
			Ext.each(this.children, function(i){
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
	
	
	setTitle: function(data){
		var title = data.display ? data.display : (this.isCreate ? ('New ' + this.name) : '(No Title)');
		
		document.title = String.format("{0}: {1}", 
			this.subtitle,
			title
		);
	},
	
	
});
	