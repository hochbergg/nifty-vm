module App
  ##
  # = StepUpdateInstance
  # Updates the entity with the field
  #
  class StepUpdateInstances < Step  
    register :update_instances
    param    :instances_hash, :type => 'Hash'
    
    ## 
    # Updates the given instance id with the given instances_hash
    #
    #
    #
    def run!
      instances_hash = @params[:instances_hash]
      instances_hash.each do |instance_id, fieldlets_hash|
        instance_id = instance_id.to_i #verify_numeric
        
        fieldlets_hash.each do |kind, value|
			  	fieldlet = @entity.fieldlets[instance_id][kind]						
        
			  	if(!fieldlet) # if there is no such fieldlet, create it
			  		field = @entity.instances[instance_id]
			  		raise "BadInstanceIdException"
			  		fieldlet = ns()::Fieldlet.get_subclass_by_id(kind).new
        
			  		field.push(fieldlet)
			  	end
			  	
			  	# set the fieldlet's value
			  	fieldlet.value = value
			  	
			  	# fetch and call any callback related to deferred loading of 
			  	# entities
			  	
			  	if callback = fieldlet.entity_update_callback
			  		callback.call(@entity.entities_to_load)
			  	end
			  end
		  end
			
    end
    
  end
end