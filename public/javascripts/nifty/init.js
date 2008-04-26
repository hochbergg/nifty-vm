/*
*	Nifty Initialization scripts
*/

// reference local blank image
Ext.BLANK_IMAGE_URL = '/ext/resources/images/default/s.gif';

// When the document is fully loaded, run init method of Nifty.app 
// in the scope of Nifty.app
Ext.onReady(Nifty.app.init, Nifty.app);


/* add routings */

Nifty.Router.add(/#\/entities\/new\/(\d+)/, function(x){
		Nifty.pages.EntityPage.create(x);
});

Nifty.Router.add(/#\/entities\/(\d+)/, function(x){
		Nifty.pages.EntityPage.load(x);
});
		
Nifty.Router.add(/#\/inbox/, function(){
	p = new Nifty.pages.Page2()
	p.load();
});

Nifty.Router.add(/#/, function(){
	p = new Nifty.pages.home()
	p.load();
});
