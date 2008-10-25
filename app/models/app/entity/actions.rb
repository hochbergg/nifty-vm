#
# = EntityActions
# A module correspond to excecuting actions on given entities
#
module App
	class Entity < Sequel::Model

    attr_reader :actions
    attr_reader :async_actions
    
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
      @async_actions = []
      actions_hash = extract_action_klasses(actions_hash)
      
      # check security
      validate_actions_permissions!(actions_hash.keys)
      
      # execute actions
      actions_hash.each do |action, params|
        if action::ASYNC
          set_async_action(action, params) 
          next
        end
        @actions << action.new(*params)
      end
      
      # load all the required entities
      self.fetch_entities_to_load()
    end
    
    
    protected
    
    ##
    # accessor for the async_actions
    # return false if no async actions were found
    #
    # @return [Array[Proc], false] a list of procs or false if no async 
    #                              actions
    #
    def async_actions
      return false if !@async_actions || @async_actions.empty?
      return @async_actions
    end
    
    
    ##
    # add the action call as a proc to the async actions queue
    #
    # @param [Class] action the action to execute
    # @param [Array] params the action params
    #
    def set_async_action(action, params)
      async_proc = proc do 
        action.new(*params)
        
        # load all the required entities
        self.fetch_entities_to_load()

        # save changes
        self.save_changes
      end
      
      @async_actions << async_proc
    end
    
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
        hash.merge!({ action => action::order_params(params)})
      end
      
      return hash
    end
   
   ##
   # Runs the constructor action, defined in the entity schema if 
   # defined
   #
   # == Notes:
   # * Constructor action must recive the current entity
   def apply_constructor!
    
     return if !self.class::CONSTRUCTOR
     
     self.class::CONSTRUCTOR.new(self)
   end
	end
end