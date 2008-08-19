module VM
	module SchemaElementTypes
		class FieldletSchemaElementType < AbstractSchemaElementType
			register 	:fieldlet
			set_model_class_name 'Fieldlet'
			has_model!
			
			
			def self.model_extra_constants(namespace, schema_element)
				prefs = schema_element.prefs
				
				field	 = schema_element.parent
				field_id = field.values[:guid]
				type  = prefs['type']
								
				{
				 'FIELD'			=> field.generated(namespace),
				 'TYPE'				=> type,
				 'FIELD_ID' 	=> field_id
				}
			end
			
			def self.model_extension(namespace, schema_element)
				# include the fieldlet mixin
				proc {
					include ::Fieldlets.const_get(self::TYPE.capitalize)
					}
			end
		end
	end
end
