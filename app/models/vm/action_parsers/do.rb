module VM

  module ActionParsers
    ##
    # = DoParser
    # Parse <do> elements
    #
    # == XML form: 
    # <do>
    #   <action href="test" />
    # </do>
    #
    # == Array form:
    # [:do,[[:action, ...], ...]
    #
    # == Ruby form: 
    # ns()::Action...
    # ...
    #
    class DoParser < AbstractParser
      register :do
      
      
      # ruby parsing
      set_before ''
      set_joiner "\n"
      set_after  ''
      
    end
  end # ActionParsers
end # VM