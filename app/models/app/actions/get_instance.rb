require 'app/models/app/action'
module App
  ##
  # = ActionGetInstance
  # 
  # Get an instance from a given entity using an instance_id
  #
  class ActionGetInstance < Action
    register 'get_instance'
    
    ASYNC = false
    PARAMS = [
      [:entity, 'App::Entity'], 
      [:instance_id, 'Int']
    ]
    
    ##
    # Run the action
    #
    # @param [App::Entity] entity the entity to fetch the instance from
    # @param [Int] instance_id the id of the instance to fetch
    # 
    def initialize(entity, instance_id)
      return if !block_given? # do nothing if no block is given
      yield entity.instances[instance_id]
    end # initialize
    
    
  end # ActionRemoveInstances
end # App