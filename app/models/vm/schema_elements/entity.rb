module VM
	module SchemaElementTypes
		class EntitySchemaElementType < AbstractSchemaElementType
			register 	:entity
			set_model_class_name 'Entity'
			has_model!
			
			
			def self.model_extra_constants(namespace,schema_element)
				field_ids = schema_element.kids_with_type(:field).
																	  collect{|e| e.values[:guid]}
				field_names = field_ids.collect{|i| "Field#{i}"}
				field_klasses = field_names.collect{|f| namespace.const_get(f)} 
				{'DISPLAY_LAMBDA' => nil,
				 'FIELD_IDS'			=> field_ids,
				 'FIELDS'					=> field_klasses
				}
			end
		end
	end
end
