

Nifty.widgets.entityPanel = Ext.extend(Nifty.widgets.mainPanel, {
	frame: false, 
	layout: 'form',
	
    setTitle : function(title, iconCls){
		title = (this.entityStore.data.isNew ?  ('New ' + Nifty.pages.current.name) : (this.entityStore.data.display || '(No Title)'));
	
        this.title = title;
        if(this.header && this.headerAsText){
  			this.headerTpl.overwrite(this.header.child('span'), this);
        }
        if(iconCls){
            this.setIconClass(iconCls);
        }
        this.fireEvent('titlechange', this, title);
        return this;
    },
	
	setSubTitle: function(subtitle){
		this.subtitle = subtitle;
		this.setTitle(this.title, this.iconCls);
	},
	
	initComponent: function(){
		Nifty.widgets.entityPanel.superclass.initComponent.call(this);
	}
});
