module VM

  module ActionParsers
    ##
    # = AddParser
    # Parse <add> elements
    #
    # == XML form: 
    # <add>
    #   <var name="first"/>
    #   <var name="second"/>
    # </add>
    #
    # == Array form:
    # [:add,[[:var, :first], [:var, :second]]]
    #
    # == Ruby form: 
    # (vars[:first] + vars[:second])
    # 
    #
    class AddParser < AbstractParser
      register :add
      children 2
      
      # ruby parsing
      set_joiner ' + '
      
    end
  end # ActionParsers
end # VM