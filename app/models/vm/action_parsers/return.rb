module VM

  module ActionParsers
    ##
    # = ReturnParser
    # Parse <return> elements
    #
    # == XML form: 
    # <return>
    #   <var name="first"/>
    # </return>
    #
    # == Array form:
    # [:return,[:var, :first]]
    #
    # == Ruby form: 
    # return (vars[:first], ...)
    # 
    #
    class ReturnParser < AbstractParser
      register :return
      
      
      # ruby parsing
      set_before 'return ('
      
    end
  end # ActionParsers
end # VM