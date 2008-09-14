module App
	class Schemas < AppController
	  provides :xml, :js
	 	  
	  def show
			id = params[:id] || @namespace::SCHEMA
	    @schema = ::VM::Schema.loaded_schemas[id]
			display @schema
	  end
	end
end