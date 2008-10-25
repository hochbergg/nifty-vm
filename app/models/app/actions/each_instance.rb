require 'app/models/app/action'
module App
  ##
  # = ActionEachInstance
  # 
  # Iterates over all the instances of a given field id
  #
  class ActionEachInstance < Action
    register 'each_instance'
    
    ASYNC = false
    PARAMS = [
      [:entity, 'App::Entity'], 
      [:field_id, 'String']
    ]
    
    ##
    # Run the action
    #
    # @param [App::Entity] entity the entity to fetch the field from
    # @param [String] field_id the field id to get the instances of
    # 
    def initialize(entity, field_id)
      return if !block_given? # do nothing if no block is given
      entity.fields[field_id].each{|i| yield i}
    end # initialize
    
    
  end # ActionRemoveInstances
end # App