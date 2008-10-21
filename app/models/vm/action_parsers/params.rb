module VM

  module ActionParsers
    ##
    # = ParamsParser
    # Parse <params> elements
    #
    # == XML form: 
    # <params>
    #     <var name="var">
    #     <int>1</int>
    # </params>
    #
    # == Array form:
    # [:params,[[:var, :first], [:int, 1]]]
    #
    # == Ruby form: 
    # (vars[:first], 1)
    # 
    #
    class ParamsParser < AbstractParser
      register :params
      
      # ruby parsers
      set_before ''
      set_after  ''
      
    end
  end # ActionParsers
end # VM