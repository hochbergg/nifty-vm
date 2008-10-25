module VM
	module SchemaElementTypes
		class EntitySchemaElementType < AbstractSchemaElementType
			register 	:entity
			set_model_class_name 'Entity'
			has_model!
			register_parser_for :entities
			
			def self.model_extra_constants(namespace,schema_element)
				field_ids = schema_element.children_with_type(:field).
																	  collect{|e| e.hex_guid}
				
				action_ids = schema_element.children_with_type(:action).
                  								  collect{|e| e.hex_guid}

        actions = {}
        
        action_ids.each do |id|
          actions[id] = namespace.const_get("Action#{id}")
        end
        
				field_names = field_ids.collect{|i| "Field#{i}"}
				field_klasses = field_names.collect{|f| namespace.const_get(f)} 
				
				title_format = schema_element.prefs['titleFormat']
				
				title_format_proc = nil
				if(title_format)
					title_format_proc = proc do |fieldlets_value|
						# replace all the guids with their ids
						return title_format.gsub(/\{[a-f0-9]{16}\}/) do |v|
						  fieldlets_value[v.sub('}','').sub('{','')].value
					  end
					end
				end
				
				constructor = schema_element.prefs['constructor']
				
				{'TITLE_FORMAT'   => title_format_proc,
				 'FIELD_IDS'			=> field_ids,
				 'FIELDS'					=> field_klasses,
				 'ACTIONS'        => actions,
				 'CONSTRUCTOR'    => constructor}
			end
			
			
			

			
		end
	end
end
