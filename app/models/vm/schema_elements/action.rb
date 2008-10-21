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
       params = prefs['prototype'][:params] || {}
       async  = prefs['async'] == true
       
       # todo params
       # todo steps
       
       # todo parameters proc
       
  		 {'PSETS'   => psets,
  		  'ASYNC' 	=> async,
        'PARAMS' => params}
			end
			
			def self.model_extension(namespace, schema_element)
			  prefs = schema_element.prefs
        to_eval = <<-STRING
        
        def initialize(#{setup_params(prefs['prototype'])})
          vars = #{initial_params_hash(prefs['prototype'])}
          validate_vars!(vars)
          
          #{ActionParsers::AbstractParser.parse_ruby_array(prefs['do'])}
        end
        STRING
        puts to_eval
        return to_eval
			end
			protected 	
			
			def self.setup_params(prototype_hash)
			  params = prototype_hash[:params].collect{|p| p.first.to_s}
			  params << '&block' if prototype_hash[:block]
			  return params.join(',')
		  end
			
			def self.initial_params_hash(prototype_hash)
			  params = prototype_hash[:params].collect do |p|
			    param = p.first
			    ":#{param} => #{param}"
			  end
			  
			  return "{#{params.join(',')}}"
		  end
		  
      
    end
	end
end
