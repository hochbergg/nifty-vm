/*
* Nifty.widgets.page
*
* Pages pack side panel and main panel
* 
*/


Nifty.widgets.page = function(options){
	Ext.apply(this,options, {})
	
	this.addEvents({
		'beforeRender': true,
		'rendered': true,
		'beforeLeave': true
	})
	
	this.init();
	this.load();
}


Ext.extend(Nifty.widgets.page, Ext.util.Observable,{
	mainPanel: null,
	sidePanel: null,
	mainComponent: Nifty.widgets.mainPanel,
	sideComponent: Nifty.widgets.sidePanel,
	
	init: function(){},
	
	load: function(data){
		this.beforeLoad(); //before load callback
		
		
		if (this.mainPanel){
			this.mainPanel = new this.mainComponent(this.mainPanel);
			this.mainPanel.render('main');
		}
		
		if (this.sidePanel){
			this.sidePanel = new this.sideComponent(this.sidePanel);
			this.sidePanel.render('side');
		}

		this.afterLoad(); // after load callback
	},
	
	beforeLoad: function(){
		this.showLoading();
		this.clear();
	},
	
	afterLoad: function(){
		this.hideLoading();
	},
	

	// destroy the current content of the page
	clear: function(){
		if (Nifty.pages.current){
			var current = Nifty.pages.current;
			
			if(current.mainPanel && current.mainPanel.destroy){ 
				current.mainPanel.destroy();}
			
			if(current.sidePanel && current.sidePanel.destroy){
				current.sidePanel.destroy();}
		}
		
		Nifty.pages.current = this;
	},
	
	
	
	showLoading: function(){
		Ext.fly('page_loading').setDisplayed(true);
		Ext.fly('main').setDisplayed(false);
		Ext.fly('side').setDisplayed(false);
	},
	
	hideLoading: function(){
		Ext.fly('page_loading').setDisplayed(false);
		Ext.fly('main').setDisplayed(true);
		Ext.fly('side').setDisplayed(true);
	},
	
	
	// handler that is called before leaving a page. 
	// if returns false, the routing will not happen, and 
	// the page will not be left
	beforeLeave: function(){
		return true;
	}
});

Nifty.pages = {
	current: null,
	fetchAndLoad: function(id){
		    new Nifty.widgets.page(Nifty.viewerInfo.pages[id]);
	  	}
	};


