module VM

  module ActionParsers
    ##
    # = EqParser
    # Parse <eq> elements
    #
    # == XML form: 
    # <eq>
    #   <var name="first"/>
    #   <var name="second"/>
    # </eq>
    #
    # == Array form:
    # [:eq,[[:var, :first], [:var, :second]]]
    #
    # == Ruby form: 
    # (vars[:first] == vars[:second])
    # 
    #
    class EqParser < AbstractParser
      register :eq
      children 2
      
      # ruby parsing
      set_joiner ' == '
      
    end
  end # ActionParsers
end # VM