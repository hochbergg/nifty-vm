require 'app/models/app/action'
module App
  ##
  # = ActionRemoveInstances
  # 
  # an optimized verision of remove_instance, for a batch remove 
  # of many instances
  #
  class ActionRemoveInstances < Action
    register 'remove_instances'
    
    ASYNC = false
    PARAMS = [
      [:entity, 'Entity'],
      [:instances, 'Array']
    ]
    
    ##
    # Run the action
    #
    # @param [App::Entity] entity the entity to remove it's fields
    # @param [Array] instances instances hash
    # 
    def initialize(entity, instances)
      instances.each do |instance_id|
 		    entity.instance[instance_id.to_i].mark_for_removal!
 		  end
    end # initialize
    
    
  end # ActionRemoveInstances
end # App