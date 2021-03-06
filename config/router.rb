# Merb::Router is the request routing mapper for the merb framework.
#
# You can route a specific URL to a controller / action pair:
#
#   r.match("/contact").
#     to(:controller => "info", :action => "contact")
#
# You can define placeholder parts of the url with the :symbol notation. These
# placeholders will be available in the params hash of your controllers. For example:
#
#   r.match("/books/:book_id/:action").
#     to(:controller => "books")
#   
# Or, use placeholders in the "to" results for more complicated routing, e.g.:
#
#   r.match("/admin/:module/:controller/:action/:id").
#     to(:controller => ":module/:controller")
#
# You can also use regular expressions, deferred routes, and many other options.
# See merb/specs/merb/router.rb for a fairly complete usage sample.

module RoutingHelper
	def self.nifty_routes(r)
		r.resources('entities', 
								:controller => 'app/entities', 
								:collection => {:search => :get}) do |e|
			e.resources 'lists', :controller => 'app/lists'
		end

		r.resources 'lists', :controller => 'app/lists'
		r.match('/schema.:format').to(:controller => 'app/schemas', :action => 'show')
		r.match('').to(:controller => 'app/home', :action =>'index')
		r.match('/').to(:controller => 'app/home', :action =>'index')
	end	
end


Merb.logger.info("Compiling routes...")
Merb::Router.prepare do |r|
  # RESTful routes


	r.resources 'schemas', :controller => 'app/schemas'
	
  # This is the default route for /:controller/:action/:id
  # This is fine for most cases.  If you're heavily using resource-based
  # routes, you may want to comment/remove this line to prevent
  # clients from calling your create or destroy actions with a GET
  
  # Change this for your home page to be available at /

	r.match("/:directory") do |dr|
		RoutingHelper::nifty_routes(dr)
	end

	RoutingHelper::nifty_routes(r)
	
	r.match('/').to(:controller => 'app/home', :action =>'index')
end