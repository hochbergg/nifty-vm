/*
* Nifty.Page
*
* Pages pack side panel and main panel
* 
*/


Nifty.Page = function(options){
	Ext.apply(this,options, {})
	
	this.addEvents({
		'beforeRender': true,
		'rendered': true
	})
}


Ext.extend(Nifty.Page, Ext.util.Observable,{
	mainPanel: null,
	sidePanel: null,
	
	load: function(data){
		this.showLoading();
		this.clear();
		
		
		if (this.mainPanel)
			this.mainPanel.render();
			
		if (this.sidePanel)
			this.sidePanel.render();

		this.hideLoading();

	},
	

	// destroy the current content of the page
	clear: function(){
		if (Nifty.pages.current){
			var current = Nifty.pages.current;
			if(current.mainPanel)
				current.mainPanel.destroy();
			
			if(current.sidePanel)
				current.sidePanel.destroy();
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

Nifty.pages = {current: null};

// Panels
Nifty.panels = {};