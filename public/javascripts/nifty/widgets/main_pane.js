/**
 * @class Nifty.widgets.mainPane 
 * @extends Ext.Container
 *
 * 
 * Layout:
 * +---------+-------------------------------------------------------------+
 * |				 |																							  						 |
 * |         |																							 +-------------+
 * |         |   Subtitle																		 |	Toolbox		 |
 * |  ICON   |		Title (subtitle)													 +-------------+
 * |   OR    |																														 |
 * |  PICT   |   +---------------------------------------------------------+
 * |				 |   | topContianer 																					 |
 * |         |   +---------------------------------------------------------+
 * +---------+-------------------------------------------------------------+
 * |			                                                                 |
 * |						  						                                             |
 * |				                                                               |
 * .                                                                       .
 * .                          MAIN CONTAINER                               .
 * .                                                                       .
 * |                                                                       |
 * |                                                                       |
 * +-----------------------------------------------------------------------+
 * |                          FOOTER CONTIANER                             |
 * |                                                                       |
 * +-----------------------------------------------------------------------+
 *
 */


Nifty.widgets.mainPane = Ext.extend(Ext.Container, {
	/**
   * @cfg {Object/Array} keys
   * A KeyMap config object (in the format expected by {@link Ext.KeyMap#addBinding} used to assign custom key
   * handling to this panel (defaults to null).
   */

	/**
   * @cfg {Object/Array} toolboxItems
   * A list of items for the Toolbox (in the format expected by {@link Ext.Toolbar} 
	 * (defaults to null).
   */

	/**
   * @cfg {Object/Array} topContainerConf
   * Configuration for the topContainer (in the format expected by {@link Ext.Container} 
	 * (defaults to null).
   */

	/**
   * @cfg {Object/Array} footerConf
   * Configuration for the footer (in the format expected by {@link Ext.Container} 
	 * (defaults to null).
   */

	 /**
    * @cfg {String} baseCls
    * The base CSS class to apply to this pane's element (defaults to 'x-nifty-pane').
    */
    baseCls : 'x-nifty-pane',


	
	
	  // private
    initComponent : function(){
        Nifty.widgets.mainPane.superclass.initComponent.call(this);

        this.addEvents(
            /**
             * @event titlechange
             * Fires after the pane title has been set or changed.
             * @param {Nifty.widgets.mainPane} p the pane which has had its title changed.
             * @param {String} The new title.
             */
            'titlechange',
            /**
             * @event subtitlechange
             * Fires after the pane subtitle has been set or changed.
             * @param {Nifty.widgets.mainPane} p the pane which has had its subtitle changed.
             * @param {String} The new subtitle.
             */
            'subtitlechange'
        );

    },	


		// private
    createElement : function(name, pnode){
        if(this[name]){
            pnode.appendChild(this[name].dom);
            return;
        }

        var el = document.createElement('div');
        el.className = String.format("{0}-{1}", this.baseCls, name);
        this[name] = Ext.get(pnode.appendChild(el));
    },


    // private
    onRender : function(ct, position){

        this.el = ct.createChild({
            id: this.id,
            cls: this.baseCls
        }, position);

        var el = this.el, d = el.dom;

        if(this.cls){
            this.el.addClass(this.cls);
        }

        // This block allows for maximum flexibility and performance when using existing markup

        this.createElement('header', d);
        this.createElement('body', d);
        this.createElement('footer', d);

        
        // append all the header elements
        var hd = this.header.dom;
				
        this.createElement('toolbox', hd);
        this.createElement('graphic', hd);
        this.createElement('title', hd);
        this.createElement('subtitle', hd);
        this.createElement('topContainer', hd);
        
       
        this.body.enableDisplayMode('block');
       
			  // setup the top container and the footer
        Ext.each(['topContainer', 'footer'], function(item){
					var items = this[item + 'Items'];
					var cmp = item + 'Cmp';
			  	if(items){ // has items
			  		this[cmp] = new Ext.Container({autoEl: 'div', items: items})
			  		this[cmp].render(this[item]);
			  		this[cmp].ownerCt = this;				
					}
			  }, this);
			  
			  
       
			  // create the action toolbar
        if(this.toolboxItems){
            if(Ext.isArray(this.toolboxItems)){
                this.toolboxCmp = new Ext.Toolbar(this.toolboxItems);
            		this.toolboxCmp.render(this.toolbox);
             		this.toolboxCmp.ownerCt = this;


            }
        }

				// setup realign of toolbox
				this.on('render', function(){
					this.toolbox.alignTo(this.header, 'r-r', [-10,0]);
				}, this, {delay: 30});
				
				

        Nifty.widgets.mainPane.superclass.onRender.call(this, ct, position);

    },

    getLayoutTarget : function(){
        return this.body;
    },

		/**
	   * Returns the toolbox of the pane
	   * @return {Ext.Toolbar} The toolbox
	   */
		getToolbox: function(){
			return this.toolboxCmp;
		},
		
		/**
	   * Returns the footer of the pane
	   * @return {Ext.Container} The footer
	   */
		getFooter: function(){
			return this.footerCmp;
		},
		
		/**
	   * Returns the top container of the pane
	   * @return {Ext.Container} The top container
	   */
		getTopContainer: function(){
			return this.topContainerCmp;
		},
		
		/**
		 * Sets the title for the pane
		 * 
		 * @param {String} title The title to set
		 */ 
		
		setTitle: function(title){
			this.title.update(title);
			// fire event
			this.fireEvent('titlechange', this, title);
		},
		
		/**
		 * Sets the subtitle for the pane
		 * 
		 * @param {String} subtitle the subtitle to set
		 */ 
		setSubTitle: function(subtitle){
			this.subtitle.update(subtitle);
			// fire event
			this.fireEvent('subtitlechange', this, subtitle);
		},
		
		
		
		//private - clean up when destroying
		beforeDestroy : function(){
        Ext.Element.uncache(
            this.header,
            this.body,
		        this.graphic,
		        this.title,
		        this.subtitle,
						this.footer,
						this.topContainer,
						this.toolbox
        );
      
        Ext.destroy(
            this.footerCmp,
            this.topContainerCmp,
            this.toolbox
        );
       Nifty.widgets.mainPane.superclass.beforeDestroy.call(this);
    },
		
		
		// private - finish the rendering
    afterRender : function(){
        if(this.titleText){
            this.setTitle(this.titleText);
        }
        if(this.subtitleText){
            this.setSubTitle(this.subtitleText);
        }
				
        Nifty.widgets.mainPane.superclass.afterRender.call(this); // do sizing calcs last

				// anchor the toolbox:
			//	this.toolbox.anchorTo(this.header, 'r-r', [-10,0], true);
    }


	
	
})