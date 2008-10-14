/*
 * Nifty-VM Ext frontend
 * Copyright(c) 2007-2008, Shlomi Atar
 * 
 * http://www.niftykm.com
 */


/**
 * @class Nifty.Router
 * @extends Ext.util.Observable
 * Used for fetching the document location hash, mathcing it to a list of
 * predifined routes, and call the function matching the route
 *
 * @constructor
 */
Nifty.Router = function(){

	this.routes = [];
	this.current_hash = null

	this.registerBaseRoutes();
	this.registerUrlPolling();
}


Ext.extend(Nifty.Router, Ext.util.Observable, {
	
	/**
	 * Adds route to the routes list
	 * 
	 * @param {Regexp} regexp Regular expression to match the url
	 * @param {Function} callback A function which will be called upon matching the
	 * 														route
	 * @param {Scope} scope The scope which the callback will be called in
	 * 
	 */
	 	add: function(regexp, callback, scope){
			this.routes.push({
				regexp: regexp,
				callback: callback,
				scope: scope
			})
		},
	
		
		/**
		 * Naviates to the given hash and re-route
		 * 
		 * @param {Object} hash url hash to be set and re-route
		 */ 
		go: function(hash){
			document.location.hash = hash;
			this.route();
		},
		
		
		/**
		 * Match the given url to a corresponding route and call the callback
		 * for the route	
		 * 
		 * @param {String} url url to match routes to
		 */ 
		routeAndCall: function(url){
			// default 
			if (url == null || url == '')
				url = "#"
			
			// iterate over the routers
			Ext.each(this.routes, function(route){
				result = route.regexp.exec(url);
				
				if(result){
					result.remove(url);
					
					if(route.scope){
						route.callback.call(route.scope, result);
						return;
					}
					
					route.callback(result);
					return; 
				}				
			},this);
			
			// if no route was found
			this.routingError(url);
		},
		
		
		/**
		 * Called when no route is found for the corresponding url
		 * 
		 * @param {String} url The url who has no route
		 */ 
		routingError: function(url){
			alert('No Route Found: ' + url);
		},
		
		/**
		 * Check if the current page can be left, and if the url hasn't change
		 */ 
		route: function(){
			if (current_hash == document.location.hash){ return;};
			
			// call the beforeLeave handler for the current page
			if (Nifty.pages.current && Nifty.pages.current.beforeLeave && (Nifty.pages.current.beforeLeave() === false))
			{
				document.location.hash = current_hash;
				return;
			}
				

			current_hash = document.location.hash;

			this.routeAndCall(document.location.hash);
		},
		
		
		/**
		 * Sets up the url monitoring
		 * 
		 */ 
		registerUrlPolling: function(){
			  this.route();
			  window.setInterval(this.route.apply(this)), 100);
		},
		
		/**
		 * Register basic routes for nifty
		 * 
		 */ 
		registerBaseRoutes: function() {

			// Creating new entities route
			this.add(/#\/entities\/new\/(\w+)/, function(x){
					Nifty.entityLoader.create(x);
			});

			// Loading entities route
			this.add(/#\/entities\/({0-9a-f}+)/, function(x){
					Nifty.entityLoader.load(x);
			});

			// Setup pages
			Ext.each(Nifty.viewerInfo.pageAddresses, function(pageAddress){
				this.add(new RegExp("#/" + pageAddress), function(){
					Nifty.pages.fetchAndLoad(pageAddress);
				});
			}, this);

			// Setup home page
			this.add(/#/, function(){
				Nifty.pages.fetchAndLoad('/');
			});		
		};
		
		
}); // End of extending Nifty.router

