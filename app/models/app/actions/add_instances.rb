require 'app/models/app/action'
module App
  ##
  # = ActionAddInstances
  # 
  # an optimized verision of add_insnace, for a batch add 
  # of many instances
  #
  class ActionAddInstances < Action
    register 'add_instances'
    
    ASYNC = false
    PARAMS = [
      [:entity, 'Entity'],
      [:instances, 'Hash']
    ]
    
    ##
    # Run the action
    #
    # @param [App::Entity] entity the entity to add fields to it
    # @param [Hash] instances instances hash
    # 
    def initialize(entity, instances)
      instances.each do |fieldlets_hash|
        field, fieldlets = ns()::Field.create_new_with_fieldlets(self, 
		    																												fieldlets_hash)
		    
		    entity.fields[field.class::IDENTIFIER] << field
		    
		    # iterate fieldlets, execute load callbacks																														
		    fieldlets.each do |fieldlet|
		    	# fetch and call any callback related to deferred loading of 
		    	# entities
		    	if callback = fieldlet.entity_create_callback
		    		callback.call(entity.entities_to_load)
		    	end
		    	
		    	# for later usage with the display generations
		    	entity.fieldlets_by_type[fieldlet.class::IDENTIFIER] ||= fieldlet
		    end
      end


    end # initialize
    
    
  end # ActionAddInstances
end # App