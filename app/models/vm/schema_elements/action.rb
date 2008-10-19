module VM
	module SchemaElementTypes
		class ActionSchemaElementType < AbstractSchemaElementType
			register 	:action
			set_model_class_name 'Action'
			has_model!
			register_parser_for :actions
			set_parent!
			
			#def self.model_extra_constants(namespace,schema_element)
  		 # prefs  = schema_element.prefs													
  		 # schema = schema_element.schema
  		 # psets  = prefs['psets'] || []
       # params = prefs['params'] || {}
       # 
       # steps = []
       # 
       # (prefs['steps'] || []).each do |step|
       #   steps << {
       #     :type => step[:type].to_sym,
       #     :param_procs => create_param_procs(step[:params])
       #   }
       # end
       # 
       # # todo params
       # # todo steps
       # 
       # # todo parameters proc
       # 
  		 # {'PSETS'      			=> psets,
  		 #  'PARAMS' 				=> params,
  		 #  'STEPS'			=> steps}
			#end
			
			def self.model_extension(namespace, schema_element)
			  prefs = schema_element.prefs
        to_eval = <<-STRING
        
        def initialize(#{setup_params(prefs['prototype'])})
          vars = #{initial_params_hash(prefs['prototype'])}
          validate_vars!(vars)
          #{cond_validation(prefs['cond'])}
          
          #{action_calls(prefs['do'])}
        end
        STRING
        puts to_eval
        return to_eval
			end
			protected 	
			
			def self.setup_params(prototype_hash)
			  params = prototype_hash[:params].collect{|p| p.keys.first.to_s}
			  params << '&block' if prototype_hash[:block]
			  return params.join(',')
		  end
			
			def self.initial_params_hash(prototype_hash)
			  params = prototype_hash[:params].collect do |p|
			    param = p.keys.first
			    ":#{param} => #{param}"
			  end
			  
			  return "{#{params.join(',')}}"
		  end
		  
		  COND_TOKENS = {
		    :eq => proc do |value|
		      return "(#{cond_token(value.first)} == #{cond_token(value.last)})"
		    end,
		    
		    :var => proc do |value|
		      return "vars[:#{value}]"
	      end
		  }
			
			def self.cond_validation(cond)
			  return "" if cond.nil?
			  
			  return "return unless #{cond_token(cond)}"
			end
			
			def self.cond_token(cond_hash)
			  result = ""
			  cond_hash.each do |k,v|
			    result << COND_TOKENS[k].call(v)
		    end
		    return result
		  end
		  
		  def self.action_calls(do_array)
		    do_array.collect{|action| action_call(action)}.join("\n")
	    end
	    
	    def self.action_call(action_hash)
	      action_name = action_hash.keys.first
	      action_info = action_hash[action_name]
	      return "ns()::Action['#{action_name}'].new(#{action_params(action_info)})"
      end
      
      def self.action_params(action_info_hash)
        
        params = action_info_hash['params'].collect{|p| extract_param(p.values.first)}
        params << block_param(action_info_hash['block']) if action_info_hash['block']
        return params.join(',')
      end
      
      def self.extract_param(param)
        
        return "'#{param}'" if param.class != Hash
        result = ""
        param.each do |k,v|
          result << COND_TOKENS[k].call(v)
        end
        return result
      end
      
      def self.block_param(block_array)
        return <<-PROC
&proc do 
            #{action_calls(block_array)}
          end 
PROC
      end
		end
	end
end
