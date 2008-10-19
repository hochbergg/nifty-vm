#
# = EntityActions
# A module correspond to excecuting actions on given entities
#
module App
	class Entity < Sequel::Model

    attr_reader :actions
    
    ##
    # Execute the actions in the given actions hash
    #
    # @param [Hash{String => Hash}] action_hash a hash with the action
    #                                           information recived from
    #                                           the client.
    #
    # === actions_hash sample
    # {<action_guid> => <parameters_hash>}
		#   { '71aa43efd0fdd671' => {'instances' => 
		#               [{'80044300905744541' => {'4589dcc19104b5ad' => 'Merb'}}]
		#                           }
    #   }
    #
    def apply_actions!(actions_hash) 
      actions_hash = extract_action_klasses(actions_hash)
      
      # check security
      validate_actions_permissions!(actions_hash.keys)
      
      # execute actions
      actions_hash.each do |action, params|
        @actions << action.new(*params)
      end
      
      # load all the required entities
      self.class.fetch_entities_with_callbacks(@entities_to_load)
    end
    
    
    protected
    
    ##
    # Validates that we can run all the given classes
    #
    # @param [Array[Class]] klasses classes to validate security on
    #
    def validate_actions_permissions!(klasses)
      # todo
    end
   
    ##
    # Create a hash from the action class to the paramters
    #
    # @param [Hash] actions_hash a hash with the action information
    #
    def extract_action_klasses(actions_hash)
      hash = {}
        
      actions_hash.each do |key, params|
        action = ns()::Action[self.class::ACTIONS["%016x" % key.to_i(16)]]
        action ||= ns()::Action[key]
        raise "BadActionType #{key}" if !action
        hash.merge!({ action => action::PARAMS_PROC.call(params,self)})
      end
      
      return hash
    end
    
	end
end