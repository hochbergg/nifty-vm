module VM

  module ActionParsers
    ##
    # = IntParser
    # Parse <int> elements
    #
    # == XML form: 
    # <int>
    #   <var name="first"/>
    # </int>
    #
    # == Array form:
    # [:int,[:var, :first]]
    #
    # == Ruby form: 
    # (vars[:first]).to_i
    # 
    #
    class IntParser < AbstractParser
      register :int
      children 1
      
      # ruby parsing
      set_joiner ').to_i'
      
    end
  end # ActionParsers
end # VM