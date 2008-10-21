module VM

  module ActionParsers
    ##
    # = GtParser
    # Parse <gt> elements
    #
    # == XML form: 
    # <gt>
    #   <var name="first"/>
    #   <var name="second"/>
    # </gt>
    #
    # == Array form:
    # [:gt,[[:var, :first], [:var, :second]]]
    #
    # == Ruby form: 
    # (vars[:first] > vars[:second])
    # 
    #
    class GtParser < AbstractParser
      register :gt
      children 2
      
      # ruby parsing
      set_joiner ' > '
      
    end
  end # ActionParsers
end # VM