# == ParamValidation
# A simple strong type/required params validation mixin

module App
  module ParamsValidation

    ##
    # Initialize the given params. sets the default values, raise exception if
    # the given param don't match the required class
    #
    # 
    def init_params!(original_params)
      validate_required_params!(original_params)
      validate_params_type!(original_params)
      set_defaults_for_params!(original_params)
    end  

    ##
    # Validates that all the required params are given
    #
    # @param [Hash] original_params the original params for validation
    #
    # @raise [RequiredParamsMismatchException] if the required params don't
    #                                          match the given params
    #
    def validate_required_params!(original_params)
      required_params = original_params.reject{|k,v| !v[:default].nil?}

      given_required_params = required_params.keys.collect{|p| @params[p]}

      raise "RequiredParamsMismatchException" if
            given_required_params.any?{|p| p.nil?}
    end

    ##
    # Validates that the given params' types matches the types required
    #
    # @param [Hash] original_params the original params of the step
    #
    # @raise [ParamsTypeMismatchException] if the given params don't
    #                                          match the required type
    #
    def validate_params_type!(original_params)
      @params.each do |p, value|
        types = original_params[p][:type]
        next if !types

        types = [types].flatten #convert to array

        raise "ParamsTypeMismatchException. got #{value.class}, expected #{types.inspect}" if !types.include? value.class.to_s 
      end
    end
    
    ##
    # Sets the default params if not given
    #
    # @param [Hash] original_params the original params of the step
    #
    def set_defaults_for_params!(original_params)
      default_params = original_params.reject{|k,v| v[:default].nil?}
      
      default_params.each do |param, value|
        next if @params[param] #skip if the param is given
        
        @params[param] = value[:default] # set the defaults
      end
    end
  end  
end
