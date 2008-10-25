require 'app/models/app/action'
module App
  ##
  # = ActionEachIndexed
  # 
  # Iterator for the given element with an indexed number
  #
  class ActionEachIndexed < Action
    register 'each_indexed'
    
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
      item.each_with_index{|element,index| yield element,index}
    end # initialize
    
    
  end # ActionRemoveInstances
end # App