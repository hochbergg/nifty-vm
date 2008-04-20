/* 
* Nifty - Router Singelton class
*
* Used for fetching the url, loading the page that is connected to it, 
* Managing history
*
*/

Nifty.Router = function(){

	var routes = [];
	var current_hash = null

	return {
		
		// add route to the routing list
		
		add: function(regexp, callback, scope){
			routes.push({
				regexp: regexp,
				callback: callback,
				scope: scope
			})
		},
		
		
		// find the needed route, call to it's constructor
		routeAndCall: function(url){
			// default 
			if (url == null || url == '')
				url = "#"
			
			// iterate over the routers
			for(i=0;i<routes.length; i++){
				result = routes[i].regexp.exec(url);
				
				if (result){
					result.remove(url)
					
					// scopes
					if (routes[i].scope){
						routes[i].callback.call(routes[i].scope, result)
						return;
					}
					
					routes[i].callback(result)
					
					return;
				}
			}
			
			this.routingError(url);
		},
		
		routingError: function(url){
			alert('No Route Found: ' + url);
		},
		
		
		route: function(){

			if (current_hash == document.location.hash){ return;};
			
			current_hash = document.location.hash;
			this.routeAndCall(document.location.hash);
		},
		
		
		/// we want the router to check every few miliseconds if the location hash changed
		registerUrlPolling: function(){
			  this.route();
			  window.setInterval(function(){
				Nifty.Router.route.call(Nifty.Router);
			}, 100);
		}
		
	}
}();


Ext.extend(Nifty.Router, Ext.util.Observable);