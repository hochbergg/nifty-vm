require 'app/models/app/action'
module App
  ##
  # = ActionSetFieldlet
  # 
  # Sets the value of a given fieldlet in a given instance
  #
  class ActionSetFieldlet < Action
    register 'set_fieldlet'
    
    ASYNC = false
    PARAMS = [
      [:instance, 'App::Field'], 
      [:fieldlet_id, 'String']
    ]
    
    ##
    # Run the action
    #
    # @param [App::Field] instance the instance to fetch the fieldlet from
    # @param [String] fieldlet_id the fieldlet id to set the value of
    # @param [Mixed] value the value to set the fieldlet to
    #
    def initialize(instance, fieldlet_id, value)
      instance.fieldlets[fieldlet_id].value = value
    end # initialize
    
    
  end # ActionRemoveInstances
end # App