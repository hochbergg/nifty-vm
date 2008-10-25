require 'app/models/app/action'
module App
  ##
  # = ActionGetFieldlet
  # 
  # Returns the value of a given fieldlet in a given instance
  #
  class ActionGetFieldlet < Action
    register 'get_fieldlet'
    
    ASYNC = false
    PARAMS = [
      [:instance, 'App::Field'], 
      [:fieldlet_id, 'String']
    ]
    
    ##
    # Run the action
    #
    # @param [App::Field] instance the instance to fetch the fieldlet from
    # @param [String] fieldlet_id the fieldlet id to get the value of
    # 
    def initialize(instance, fieldlet_id)
      return instance.fieldlets[fieldlet_id].value
    end # initialize
    
    
  end # ActionRemoveInstances
end # App