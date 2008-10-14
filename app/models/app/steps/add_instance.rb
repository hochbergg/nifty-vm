
module App
  ##
  # = StepAddInstance
  # Add an instance with the given fieldlet_hash
  #
  class StepAddInstances < Step  
    register :add_instances
    param    :instances,       :type => 'Array'
    
    ## 
    # Add a new instance with the given fieldlets_hash
    #
    def run!
      instances = @params[:instances]
      
      instances.each do |fieldlets_hash|
        field, fieldlets = @action.ns()::Field.create_new_with_fieldlets(self, 
		    																												fieldlets_hash)
		    
		    @entity.fields[field.class::IDENTIFIER] << field
		    
		    # iterate fieldlets, execute load callbacks																														
		    fieldlets.each do |fieldlet|
		    	# fetch and call any callback related to deferred loading of 
		    	# entities
		    	if callback = fieldlet.entity_create_callback
		    		callback.call(@entity.entities_to_load)
		    	end
		    	
		    	# for later usage with the display generations
		    	@entity.fieldlets_by_type[fieldlet.class::IDENTIFIER] ||= fieldlet
		    end
      end																					
		  
    end
    
  end
end