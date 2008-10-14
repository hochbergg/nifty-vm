module VM
	module SchemaElementTypes
		class ActionSchemaElementType < AbstractSchemaElementType
			register 	:action
			set_model_class_name 'Action'
			has_model!
			register_parser_for :actions
			set_parent!
			
			def self.model_extra_constants(namespace,schema_element)
  			prefs  = schema_element.prefs													
  			schema = schema_element.schema
  			psets  = prefs['psets'] || []
        params = prefs['params'] || {}
        
        steps = []
        
        (prefs['steps'] || []).each do |step|
          steps << {
            :type => step[:type].to_sym,
            :param_procs => create_param_procs(step[:params])
          }
        end
        
        # todo params
        # todo steps
        
        # todo parameters proc
        
  			{'PSETS'      			=> psets,
  			 'PARAMS' 				=> params,
  			 'STEPS'			=> steps}
			end
			
			protected 
			
			##
			# Creates a hash of procs which will retrive the params
			#
			# @param [Hash] params_hash a list of params
			# 
			# @return [Hash{Symbol => Proc}] the params proc hash
			def self.create_param_procs(params_hash)
			  procs_hash = {}
			  
			  params_hash.each do |param, value|
			    procs_hash[param.to_sym] = create_param_proc(value)			    
		    end
		    
		    return procs_hash
			end
			
			##
			# Creates a param fetching proc from the given value
			# 
			# @param [String] value the value defined on the step config
			# 
			# @return [Proc] the param fetching proc
			def self.create_param_proc(value)			  
			  case value[0,1]
		      when '@'
		        param = value[1,value.size() -1]
		        return proc{|entity, action| action.params[param]}
	        when '#'
	          fieldlet_id = value[1,value.size() -1]
	          return proc{|en, act| en.fieldlets_by_type[fieldlet_id].value}
          else
            return proc{|entity,action| return value}
          end
		  end
			
		end
	end
end
