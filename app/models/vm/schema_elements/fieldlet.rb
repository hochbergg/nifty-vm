module VM
	module SchemaElementTypes
		class FieldletSchemaElementType < AbstractSchemaElementType
			register 	:fieldlet
			set_model_class_name 'Fieldlet'
			has_model!
			
			
			def self.model_extra_constants(namespace, schema_element)
				prefs = schema_element.prefs
				
				field	 = schema_element.parent
				field_id = field.values[:identifier]
				type  = prefs[:type]
								
				{
				 'FIELD'			=> field.generated(namespace),
				 'TYPE'				=> type,
				 'FIELD_ID' 	=> field_id
				}
			end
		end
	end
end
