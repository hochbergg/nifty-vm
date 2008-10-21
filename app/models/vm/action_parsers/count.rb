module VM

  module ActionParsers
    ##
    # = CountParser
    # Parse <count> elements
    #
    # == XML form: 
    # <count>
    #   <var name="first"/>
    # </count>
    #
    # == Array form:
    # [:count,[:var, :first]]
    #
    # == Ruby form: 
    # (vars[:first]).size
    # 
    #
    class CountParser < AbstractParser
      register :count
      children 1
      
      # ruby parsing
      set_after ').size'
      
    end
  end # ActionParsers
end # VM