/*
*	Nifty Initialization scripts
*/

// reference local blank image
Ext.BLANK_IMAGE_URL = '/ext/resources/images/default/s.gif';

// When the document is fully loaded, run init method of Nifty.app 
// in the scope of Nifty.app
Ext.onReady(Nifty.app.init, Nifty.app);


/* add routings */

Nifty.Router.add(/#\/entities\/new\/(\w+)/, function(x){
		Nifty.entityLoader.create(x);
});

Nifty.Router.add(/#\/entities\/(\d+)/, function(x){
		Nifty.entityLoader.load(x);
});

// setup pages

Ext.each(Nifty.viewerInfo.pageAddresses, function(pageAddress){
	Nifty.Router.add(new RegExp("#/" + pageAddress), function(){
		Nifty.pages.fetchAndLoad(pageAddress);
	});
});

Nifty.Router.add(/#/, function(){
	Nifty.pages.fetchAndLoad('/');
});
