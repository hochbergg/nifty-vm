module VM
	module SchemaElementTypes
		class AbstractSchemaElementType
			@@has_models = {}
			@@model_class_name = {}
			
			def self.has_model!
				@@has_models[self] = true
			end
			
			def self.has_model?
				@@has_models[self]
			end
			
			def self.build_model(namespace, schema_element)
				identifier = schema_element.values[:guid]
				preferences = schema_element.prefs #load prefs
				preferences = preferences.dup if preferences
				model_klass = namespace.const_set("#{@@model_class_name[self]}#{identifier}", 
																Class.new(namespace.const_get(@@model_class_name[self])))

				# set class variables
				model_klass.const_set('NAME', schema_element.values[:name])
				model_klass.const_set('IDENTIFIER', identifier)
				model_klass.const_set('PREFS', preferences)
				model_klass.const_set('SCHEMA', schema_element.values[:schema])


				
				# setup model iheritance
				model_klass.set_inheritance! if model_klass.respond_to?(:set_inheritance!)
				if (model_klass.respond_to?(:before_create))
					model_klass.class_eval do				
						# set the STI key to the proper kind
						before_create :set_sti_key
						def set_sti_key
							self[:kind] = self.class::IDENTIFIER
						end
					end
				end
				

				
				return model_klass
			end
			
			def self.set_extras_for_model(namespace, schema_element)
				model_klass = namespace.const_get("#{@@model_class_name[self]}#{schema_element.values[:guid]}")
				
				# add extra consts
				if respond_to?(:model_extra_constants)
					model_extra_constants(namespace,schema_element).each do |k, v|
						model_klass.const_set(k, v)
					end
				end
				
				# load extra methods
				model_klass.class_eval &model_extension(namespace,schema_element) if respond_to?(:model_extension)

			end
			
			def self.set_model_class_name(model_name)
				@@model_class_name[self] = model_name
			end
			
			def self.model_class_name
				@@model_class_name[self]
			end
		
			
			def self.register(symbol)
				SchemaElement.register_element_type(symbol, self)
			end
		end
	end
end