require 'app/models/app/action'
module App
  ##
  # = ActionUpdateInstances
  # 
  # an optimized verision of update_insnace, for a batch update 
  # of many instances
  #
  class ActionUpdateInstances < Action
    register 'update_instances'
    
    ASYNC = false
    PARAMS = [
      [:entity, 'Entity'],
      [:instances, 'Hash']
    ]
    
    ##
    # Run the action
    #
    # @param [App::Entity] entity the entity to update it's fields
    # @param [Hash] instances instances hash
    # 
    def initialize(entity, instances)
      instances.each do |instance_id, fieldlets_hash|
        instance_id = instance_id.to_i #verify_numeric
        
        fieldlets_hash.each do |kind, value|
			  	fieldlet = entity.fieldlets[instance_id][kind]						
        
			  	if(!fieldlet) # if there is no such fieldlet, create it
			  		field = entity.instances[instance_id]
			  		raise "BadInstanceIdException"
			  		fieldlet = ns()::Fieldlet.get_subclass_by_id(kind).new
        
			  		field.push(fieldlet)
			  	end
			  	
			  	# set the fieldlet's value
			  	fieldlet.value = value
			  	
			  	# fetch and call any callback related to deferred loading of 
			  	# entities
			  	
			  	if callback = fieldlet.entity_update_callback
			  		callback.call(entity.entities_to_load)
			  	end # if
			  end # fieldlets_hash.each
		  end  # instances.each 
    end # initialize
    
    
  end # ActionUpdateInstances
end # App