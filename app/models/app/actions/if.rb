require 'app/models/app/action'
module App
  ##
  # = ActionIf
  # 
  # runs the given block if the condition is true
  #
  class ActionIf < Action
    register 'if'
    
    ASYNC = false
    PARAMS = [
      [:cond, 'Boolean']
    ]
    
    ##
    # Run the action
    #
    # @param [Boolean] cond the condition result  boolean
    # 
    def initialize(cond)
      return if !block_given?
      return if !cond
      yield
    end # initialize
    
    
  end # ActionRemoveInstances
end # App