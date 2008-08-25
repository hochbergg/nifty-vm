module App
	class Schemas < AppController
	  provides :xml, :js
	 	  
	  def show
			#UGLY
			return latest if params[:id] == 'latest'
		
	    @schema = ::VM::Schema.loaded_schemas[params[:id].to_i(16)]
			display @schema
	  end
	  
		def latest
			@schema = ::VM::Schema.loaded_schemas.values.first
			display @schema
		end
	
	end
end