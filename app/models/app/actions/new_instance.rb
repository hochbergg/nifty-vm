require 'app/models/app/action'
module App
  ##
  # = ActionNewInstance
  # 
  # Create new instance in the given entity and field_id
  #
  class ActionEachInstance < Action
    register 'new_instance'
    
    ASYNC = false
    PARAMS = [
      [:entity, 'App::Entity'], 
      [:field_id, 'String']
    ]
    
    ##
    # Run the action
    #
    # @param [App::Entity] entity the entity to add the instance to
    # @param [String] field_id the field id to add the new instance to
    # 
    def initialize(entity, field_id)
      return if !block_given? # do nothing if no block is given
      field = entity.fields[field_id]
      instance = entity.class::FIELDS.find{|x| x::IDENTIFIER == field_id}.new
      yield instance
      field << instance
    end # initialize
    
    
  end # ActionRemoveInstances
end # App