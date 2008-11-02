/**
 * @class Nifty.widgets.Page 
 * @extends Ext.util.Observable
 * 
 * The main display element of the nifty app.
 * <p>Packs two elements: the right side element and the main side element</p>
 *
 *  @constructor
 */ 
Nifty.widgets.page = function(options){
	Ext.apply(this,options, {})

	this.addEvents({
		'beforeRender': true,
		'rendered': true,
		'beforeLeave': true
	})

	this.init();
	this.render();
}


Ext.extend(Nifty.widgets.page, Ext.util.Observable,{
	
	/**
   * @cfg {Function} mainComponent
   * The main component to draw 
   */
 	mainComponent: Nifty.widgets.mainPane,

	/**
   * @cfg {Function} sideComponent
   * The side component to draw 
   */
	sideComponent: Nifty.widgets.sidePane,

  /**
    * The instance of the mainComponent
    * @type Ext.Component
    * @property main
    */

	/**
	  * The instance of the sideComponent
	  * @type Ext.Component
	  * @property side
	  */
	
	/**
	 * @cfg {Object} mainConf
	 * The main component configuration
	 */
	
	/**
	 * @cfg {Object} sideConf
	 * The side component configuration
	 */

	/**
	 * Initializer function, called before the load function
	 * 
	 * @overidable
	 */ 
	init: function(){},

	/**
	 * Renders the page to the document
	 * 
	 */ 
	render: function(){
  	//before load callback
		this.beforeRender();


		if (this.mainConf){ // The main panel config
			this.main = new this.mainComponent(this.mainConf);
			this.main.hidden = true; // set as hidden
			this.main.render('main'); // render to DIV#main
		}

		if (this.sideConf){ // The side panel config
			this.side = new this.sideComponent(this.sideConf);
			this.side.hidden = true; // set as hidden
			this.side.render('side'); // render to DIV#side
		}
		
		// afterRender callback
		this.afterRender();
	},


	/**
	 * A callback which called before  the page is rendered
	 * 
	 * <p>This callback shows the loading bar, and clear the current page</p>
	 */ 
	beforeRender: function(){
		this.showLoading();
		this.clear();
	},

	/**
	 * A callback which called after the page is rendered
	 * 
	 * <p>This callback hides the loading bar</p>
	 */
	afterRender: function(){
		this.hideLoading();
	},


	/**
	 * Clears the page from the current loaded page
	 * 
	 * <p>Removes the current content of the page, sets the current page</p>
	 */
	clear: function(){
		if (Nifty.app.currentPage){
			var current = Nifty.app.currentPage;

			if(current.main && current.main.destroy){current.main.destroy();}
			if(current.side && current.side.destroy){current.side.destroy();}
		}
   
		// Sets the current page
		Nifty.app.currentPage = this;
	},


	/**
	 * Hides DIV#main and DIV#side and show the DIV#page_loading
	 */ 
	showLoading: function(){
		Ext.fly('page_loading').setDisplayed(true);
		Ext.fly('main').setDisplayed(false);
		Ext.fly('side').setDisplayed(false);

	},


	/**
	 * Hides DIV#page_loading and shows the main and sie panels
	 */
	hideLoading: function(){
		Ext.fly('page_loading').setDisplayed(false);

		if (this.main){this.main.show();}
		if (this.side){this.side.show();}
		Ext.fly('main').setDisplayed(true);
		Ext.fly('side').setDisplayed(true);
	},


	/**
	 * This callback is called before the page is left.
	 * if it return false, the routing will not happen. 
	 * 
	 * @return {Boolean} if returned false, will stop the routing 
	 */ 
	beforeLeave: function(){
		return true;
	}
	
});


