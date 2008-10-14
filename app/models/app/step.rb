require 'app/models/app/action'
require 'params_validation'

module App
  ##
  # = Step
  # A basic building block for action
  #
  class Step
    include ParamsValidation
    
    @@params ||= Hash.new{|hash, key| hash[key] = {}}
    
    ##
    # Runs a step on a given entity
    # 
    # @param [App::Entity] entity entity to run on
    # @param [Class < App::Action] action, the action class 
    # @param [Hash{Symbol => Object}] params The parameters needed
    # 
    #
    def initialize(entity, action, params = {})
      @entity = entity
      @params = params.dup
      @action = action
      self.run_params_procs!
      self.init_params!(self.class.params)
      self.run!
    end
    
    ##
    # iterate the params, extracting the params procs values
    #
    def run_params_procs!
     @params.each do |p, proc|
       @params[p] = proc.call(@entity, @action)
     end
    end
    ##
    # Runs the action.
    # <b> Must be overriden by subclasses </b>
    # @overriden
    #
    def run
      raise NotImplementedError
    end
    
    
    protected :init_params!, 
              :validate_params_type!,
              :validate_required_params!

    
    
    #== Class methods
    
    ##
    # Register the step with a given symbol
    #
    # @param [Symbol] symbol A symbol to register the step with
    #
    def self.register(symbol)
      Action.register_step(symbol, self)
    end
    
    
    ##
    # Adds a parameter to the list of parameters
    # 
    # @param [Symbol] name paramter name as symbol
    # @param [Hash] options options for the param, see notes
    #             
    # === Options:
    # * type :: a list of classes that the param value must be one of them
    #
    # * default :: a default value to apply if the param is not given
    def self.param(symbol, options = {})
      @@params[self][symbol] = options
    end
    
    ##
    # Return a list of the parameters that the step takes
    #
    # @return [Hash{Symbol=>[Class]}] a hash of parameters and their types
    #
    def self.params
      @@params[self]
    end
    
    
  end
end