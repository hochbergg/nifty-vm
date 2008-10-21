module VM

  module ActionParsers
    ##
    # = YieldParser
    # Parse <yield> elements
    #
    # == XML form: 
    # <yield>
    #   <var name="first"/>
    #   <var name="second"/>
    # </yield>
    #
    # == Array form:
    # [:yield,[[:var, :first],..]]
    #
    # == Ruby form: 
    # yield vars[:first], ...
    # 
    #
    class YieldParser < AbstractParser
      register :yield
      
      
      # ruby parsing
      set_before 'yield('
      
    end
  end # ActionParsers
end # VM