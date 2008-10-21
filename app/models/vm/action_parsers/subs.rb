module VM

  module ActionParsers
    ##
    # = SubsParser
    # Parse <subs> elements
    #
    # == XML form: 
    # <subs>
    #   <var name="first"/>
    #   <var name="second"/>
    # </subs>
    #
    # == Array form:
    # [:subs,[[:var, :first], [:var, :second]]]
    #
    # == Ruby form: 
    # (vars[:first] - vars[:second])
    # 
    #
    class SubsParser < AbstractParser
      register :subs
      children 2
      
      # ruby parsing
      set_joiner ' - '
      
    end
  end # ActionParsers
end # VM