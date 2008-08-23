/*
 * Nifty KM
 * 
 * http://niftykm.com
 */

/**
 * @class Nifty.widgets.mainPanel
 * @extends Ext.Panel
 *
 * Simple Platform for the main nifty panel
 * 
 * @constructor
 * @param {Object} config The config object
 */


Nifty.widgets.mainPanel = Ext.extend(Ext.Panel, {
	title: "Loading...",
    /**
    * @cfg {String} baseCls
    * The base CSS class to apply to this panel's element (defaults to 'x-panel').
    */
    baseCls : 'x-panel-nifty-main',
    /**
    * @cfg {String} collapsedCls
    * A CSS class to add to the panel's element after it has been collapsed (defaults to 'x-panel-collapsed').
    */
    collapsedCls : 'x-panel-nifty-main-collapsed',


   /**
     * Sets the title text for the panel and optionally the icon class.
     * @param {String} title The title text to set
     * @param {String} (optional) iconCls A custon, user-defined CSS class that provides the icon image for this panel
     */
    setTitle : function(title, iconCls){
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
   	

	/**
     * Sets the CSS class that provides the icon image for this panel.  This method will replace any existing
     * icon class if one has already been set.
     * @param {String} cls The new CSS class name
     */
    setIconClass : function(cls){
        var old = this.iconCls;
        this.iconCls = cls;
        if(this.rendered && this.header){
                this.header.child('span').addClass('x-panel-nifty-main-icon');
                this.header.child('span').replaceClass(old, this.iconCls);
        }
    },


	headerTpl: new Ext.XTemplate('<h4>{subtitle}</h4>','<h2>{title}</h2>')
	
});
