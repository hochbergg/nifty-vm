module VM

  module ActionParsers
    ##
    # = MultParser
    # Parse <mult> elements
    #
    # == XML form: 
    # <mult>
    #   <var name="first"/>
    #   <var name="second"/>
    # </mult>
    #
    # == Array form:
    # [:mult,[[:var, :first], [:var, :second]]]
    #
    # == Ruby form: 
    # (vars[:first] * vars[:second])
    # 
    #
    class MultParser < AbstractParser
      register :mult
      children 2
      
      # ruby parsing
      set_joiner ' * '
      
    end
  end # ActionParsers
end # VM