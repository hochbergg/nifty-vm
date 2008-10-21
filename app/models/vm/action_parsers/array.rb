module VM

  module ActionParsers
    ##
    # = ArrayParser
    # Parse <array> elements
    #
    # == XML form: 
    # <array>
    #   <var name="first"/>
    # </array>
    #
    # == Array form:
    # [:array,[:var, :first]]
    #
    # == Ruby form: 
    # array (vars[:first], ...)
    # 
    #
    class ArrayParser < AbstractParser
      register :array
      
      
      # ruby parsing
      set_before '['
      set_after  ']'
      
    end
  end # ActionParsers
end # VM