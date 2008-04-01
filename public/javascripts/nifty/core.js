/**
  * Nifty Core Application
  * by Shlomi Atar
  */
 

Ext.namespace('Nifty', 
			  'Nifty.Utils', 
			  'Nifty.Data', 
			  'Nifty.Data.Entity', 
			  'Nifty.Data.Fieldlet',
			  'Nifty.form');




// A panel with a replace ability
Nifty.Utils.ReplaceablePanel = Ext.extend(Ext.Panel, {
	layout: 'card',
	activeItem: 0,
   	defaults: {
       border:false
   	},

	replace: function(panel){
		if (this.items.first()){
			this.remove(this.items.first())
		}

		this.add(panel)
		this.layout.setActiveItem(0)
		this.doLayout();
	}
})


// create application
Nifty.app = function() {
    // do NOT access DOM from here; elements don't exist yet
 
    // private variables
 
    // private functions
 
    // public space
    return {
 
        // public methods
		hideLoaders: function(){
		   setTimeout(function(){
		    	Ext.get('loading').remove();
		    	Ext.get('loading-mask').fadeOut({remove:true});
		    }, 250);	
		},


        init: function() {
			// Hide Loader
			this.hideLoaders()
			this.setLayout()
			
			this.centerPanel.replace(new Entity2(
				{
					items: [
						{
							id: 'field_1',
							title: 'Field1',
							xtype: 'niftyField',
							items:[
								{
									id: 'entity[7][0]',
									xtype: 'Fieldlet7'
								},
								{
									id: 'entity[8][0]',
									xtype: 'Fieldlet8'
								}

							]
						}   
					]
				}
				))
        },


		setLayout: function(){
			new Ext.Viewport({
				scope:this,
			    layout: 'border',
			    defaults: {
			        activeItem: 0,
			    },
			    items: [this.centerPanel,this.sidePanel]
			});
			
		}
		,
		
		
		
		
		// Our Center Panel, Display the main info
		centerPanel: new Nifty.Utils.ReplaceablePanel({
            region: 'center',
            margins: '0 0 0 0',
			id: 'center_panel',
		
		}),
		
		sidePanel: new Ext.Panel({
		   region: 'east',
		   xtype: 'panel',
		   title: 'Side',
		   width: 200
		})
		
    };
}(); // end of app
 