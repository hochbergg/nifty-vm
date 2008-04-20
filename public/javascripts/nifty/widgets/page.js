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
	
	load: function(data){
		Ext.fly('page_loading').setDisplayed(true)		
		
		// clear
		if (Nifty.pages.current){
			var current = Nifty.pages.current;
			if(current.mainPanel)
				current.mainPanel.destroy();
			
			if(current.sidePanel)	
				current.sidePanel.destroy();
		}
		
		
		if (this.mainPanel)
			this.mainPanel.render();
			
		if (this.sidePanel)
			this.sidePanel.render();

		Ext.fly('page_loading').setDisplayed(false)
		Nifty.pages.current = this;
	},
	
	mainPanel: null,
	sidePanel: null,
	
});

Nifty.pages = {};

Nifty.pages.current = null;

// Panels
Nifty.panels = {};