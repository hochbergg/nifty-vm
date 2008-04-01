/*
*	Nifty Initialization scripts
*/

// reference local blank image
Ext.BLANK_IMAGE_URL = '/ext/resources/images/default/s.gif';

// When the document is fully loaded, run init method of Nifty.app 
// in the scope of Nifty.app
Ext.onReady(Nifty.app.init, Nifty.app);
