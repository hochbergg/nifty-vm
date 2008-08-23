module App
	class Schemas < AppController
	  provides :xml, :js
	 	  
	  def show
	    @schema = ::VM::Schema.loaded_schemas[params[:id]]
			display @schema
	  end
	  
	end
end