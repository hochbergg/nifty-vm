module VM
	module SchemaElementTypes
		class EntitySchemaElementType < AbstractSchemaElementType
			register 	:entity
			set_model_class_name 'Entity'
			has_model!
			
			
			def self.model_extra_constants(namespace,schema_element)
				field_ids = schema_element.children_with_type(:field).
																	  collect{|e| e.hex_guid}
				field_names = field_ids.collect{|i| "Field#{i}"}
				field_klasses = field_names.collect{|f| namespace.const_get(f)} 
				
				display = schema_element.prefs['displayLambda']
				
				display_lambda = nil
				if(display)
					display_lambda = proc do |fieldlets_value|
						# replace all the guids with their ids
						return display.gsub(/[a-f0-9]{16}/){|v| fieldlets_value[v].value}
					end
				end
				
				
				{'DISPLAY_LAMBDA' => display_lambda,
				 'FIELD_IDS'			=> field_ids,
				 'FIELDS'					=> field_klasses}
			end
		end
	end
end
