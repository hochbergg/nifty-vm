# App base controller

module App
	SCHEMA_ROUTES = {:directory => {}, :host => {}, :catch_all => nil}
	
	class AppController < Application
		layout :app
		before :set_namespace
		
		def set_namespace
				if params[:directory] && namespace = App::SCHEMA_ROUTES[:directory][params[:directory]]
					@namespace_path = "/#{params[:directory]}"
					@namespace = namespace
					return
				end
				
				if namespace = App::SCHEMA_ROUTES[:host][request.host] 
					@namespace_path = '/'
					@namespace = namespace
					return
				end
				
				if namespace = App::SCHEMA_ROUTES[:catch_all]
					@namespace_path = '/'
					@namespace = namespace
					return
				end
				
				raise NotFoundException
		end
	end
end