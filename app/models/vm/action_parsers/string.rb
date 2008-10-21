module VM

  module ActionParsers
    ##
    # = StringParser
    # Parse <string> elements
    #
    # == XML form: 
    # <string>
    #   <var name="first"/>
    # </string>
    #
    # == Array form:
    # [:string,[:var, :first]]
    #
    # == Ruby form: 
    # (vars[:first]).to_str
    # 
    #
    class StringParser < AbstractParser
      register :string
      children 1
      
      
      # ruby parsing
      set_after '.to_s'
      
    end
  end # ActionParsers
end # VM