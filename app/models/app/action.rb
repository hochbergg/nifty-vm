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
    def initialize(*args)
      raise NotImplementedError
    end
    
    def validate_vars!(vars)
    end

    ##
    # order a given params hash as an array of parameters to send
    # to the constructor of the action
    #
    # @param [Hash] param_hash the parameters to send to the action
    # @return [Array] array array of parameters to send to the action constructor
    #
    def self.order_params(params_hash)
      params = []
      self::PARAMS.each do |p|
        param = parmas_hash[p.first]
        raise ArgumentError if !param
        params << param
      end
    end
  end

  
end