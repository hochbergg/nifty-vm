module VM

  module ActionParsers
    ##
    # = NotParser
    # Parse <not> elements
    #
    # == XML form: 
    # <not>
    #   <var name="first"/>
    # </not>
    #
    # == Array form:
    # [:not,[:var, :first]]
    #
    # == Ruby form: 
    # (!vars[:first])
    # 
    #
    class NotParser < AbstractParser
      register :not
      children 1
      
      
      # ruby parsing
      set_before '(!'
      
    end
  end # ActionParsers
end # VM