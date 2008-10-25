require 'app/models/app/action'
module App
  ##
  # = ActionEach
  # 
  # Iterator for the given element
  #
  class ActionEach < Action
    register 'each'
    
    ASYNC = false
    PARAMS = [
      [:item, '#each']
    ]
    
    ##
    # Run the action
    #
    # @param [#each] item the item to iterate
    # 
    def initialize(item)
      return if !block_given?
      item.each{|i| yield i}
    end # initialize
    
    
  end # ActionRemoveInstances
end # App