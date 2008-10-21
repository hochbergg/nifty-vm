module VM

  module ActionParsers
    ##
    # = OrParser
    # Parse <or> elements
    #
    # == XML form: 
    # <or>
    #   <var name="first"/>
    #   <var name="second"/>
    # </or>
    #
    # == Array form:
    # [:or,[[:var, :first], [:var, :second]]]
    #
    # == Ruby form: 
    # (vars[:first] or vars[:second])
    # 
    #
    class OrParser < AbstractParser
      register :or
      children 2
      
      # ruby parsing
      set_joiner ' or '
      
    end
  end # ActionParsers
end # VM