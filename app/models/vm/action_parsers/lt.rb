module VM

  module ActionParsers
    ##
    # = LtParser
    # Parse <lt> elements
    #
    # == XML form: 
    # <lt>
    #   <var name="first"/>
    #   <var name="second"/>
    # </lt>
    #
    # == Array form:
    # [:lt,[[:var, :first], [:var, :second]]]
    #
    # == Ruby form: 
    # (vars[:first] < vars[:second])
    # 
    #
    class LtParser < AbstractParser
      register :lt
      children 2
      
      # ruby parsing
      set_joiner ' < '
      
    end
  end # ActionParsers
end # VM