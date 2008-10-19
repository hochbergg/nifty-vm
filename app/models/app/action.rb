module App
  ## 
  # = Action
  #
  #
  class Action
		include Namespacing
    @@actions ||= {}
    
    
    ##
    # register the action class with the given name
    #
    # @param [String] name the name to register the class with
    # @param [Class] klass a class to register with
    def self.register(name, klass = self)
      @@actions[name] = klass
    end
    
    ##
    # register a proc as an action 
    #
    # @param [String] name the name to register the proc with
    # @param [Proc] proc  the proc to register as an action
    def self.register_proc(name, &proc)
      @@actions[name] = proc
    end
    
    ##
    # accessor for @@actions#[]
    #
    # @param [String] name the name of the action
    def self.[](name)
      raise "ActionNotFoundError" if !action = @@actions[name]
      return action
    end

    ##
    # Initialize the action
    # must be overiden
    def initialize(params, entity = nil)
      raise NotImplementedError
    end
    
    def validate_vars!(vars)
    end
  end
end