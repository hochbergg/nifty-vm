module VM

  module ActionParsers
    ##
    # = AndParser
    # Parse <and> elements
    #
    # == XML form: 
    # <and>
    #   <var name="first"/>
    #   <var name="second"/>
    # </and>
    #
    # == Array form:
    # [:and,[[:var, :first], [:var, :second]]]
    #
    # == Ruby form: 
    # (vars[:first] and vars[:second])
    # 
    #
    class AndParser < AbstractParser
      register :and
      children 2
      
      # ruby parsing
      set_joiner ' and '
      
    end
  end # ActionParsers
end # VM