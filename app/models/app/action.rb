require 'params_validation'

module App
  ##
  # = Action 
  # Contain steps which updates the entity. 
  #
  class Action
    include Namespacing
    include ParamsValidation
    @@registerd_steps ||= {}
    
    attr_reader :params
    
    ##
    # Create a new instance of the action, validates the given params
    # and executes the steps
    #
    # @param [App::Entity] entity the entity which runs the actions
    # @param [Hash] params the given action params
    #
    def initialize(entity, params)
      @entity, @params = entity, params
      @steps = []
      init_params!(self.class::PARAMS)
      run_steps!
    end
    
    
 
    
    
    ##
    # Runs the predefined steps
    #
    def run_steps!
      self.class::STEPS.each do |step|
        step_klass = @@registerd_steps[step[:type]]
        @steps << step_klass.new(@entity,self,step[:param_procs])
      end
    end
    
    # == Class methods
    
    ##
    # Registers a given step class 
    # 
    # @param [Symbol] symbol The symbol to represent the step
    # @param [App::Step] step_klass The step class
    #
    def self.register_step(symbol, step_klass)
      @@registerd_steps[symbol] = step_klass
    end
    
    ##
    # accessor for @@registerd_steps
    #
    # @return [Hash] the registerd steps hash
    def self.steps
      @@registerd_steps
    end
    
    protected :init_params!, 
              :validate_params_type!,
              :validate_required_params!,
              :run_steps!
    
    
  end
end