

Nifty.widgets.EntityPanel = Ext.extend(Nifty.widgets.MainPanel, {

    setTitle : function(title, iconCls){
		title = this.entityStore.data.display;
	
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
});