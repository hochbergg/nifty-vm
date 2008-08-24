module App
	class Schemas < AppController
	  provides :xml, :js
	 	  
	  def show
	    @schema = ::VM::Schema.loaded_schemas[params[:id]]
			display @schema
	  end
	  
		def latest
			@schema = ::VM::Schema.loaded_schemas.values.first
			display @schema
		end
	
	end
end