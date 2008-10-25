require 'app/models/app/action'
module App
  ##
  # = ActionRemoveInstance
  # 
  # removes the given instance
  #
  class ActionRemoveInstance < Action
    register 'remove_instance'
    
    ASYNC = false
    PARAMS = [
      [:instance, 'App::Instance']
    ]
    
    ##
    # Run the action
    #
    # @param [Boolean] cond the condition result  boolean
    # 
    def initialize(instance)
      instance.mark_for_removal!
    end # initialize
    
    
  end # ActionRemoveInstances
end # App