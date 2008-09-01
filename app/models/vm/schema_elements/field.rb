module VM
	module SchemaElementTypes
		class FieldSchemaElementType < AbstractSchemaElementType
			register 	:field
			set_model_class_name 'Field'
			has_model!
			
			
			def self.model_extra_constants(namespace,schema_element)
				fieldlet_ids = schema_element.children_with_type(:fieldlet).
																	  collect{|e| e.values[:guid]}
				prefs  = schema_element.prefs													
				schema = schema_element.schema
				duplication = prefs['duplication']
				
				fieldlet_names 	 = fieldlet_ids.collect{|i| "Fieldlet#{i}"}
				fieldlet_klasses = fieldlet_names.collect{|f| namespace.const_get(f)} 
				link_fieldlet 	 = schema[duplication['link_fieldlet'].to_i(16)].values[:guid] if duplication && duplication['link_fieldlet']

				duplication_hash = nil
				if duplication
					duplication_hash = {}
					duplication['target_classes'].each do |k,v|
						duplication_hash[schema[k.to_i(16)].generated(namespace)] = schema[v.to_i(16)].generated(namespace)
					end
				end
				
				{'FIELDLET_IDS'			=> fieldlet_ids,
				 'FIELDLETS' 				=> fieldlet_klasses,
				 'DUPLICATION'			=> duplication_hash,
				 'LINK_FIELDLET'    => link_fieldlet}
			end
		end
	end
end