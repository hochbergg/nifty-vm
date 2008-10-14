module VM
	module SchemaElementTypes
		class AbstractSchemaElementType
			@@has_models            ||= {}
			@@model_class_name      ||= {}
	    @@should_set_parent     ||= {}
	    @@schema_elements_types ||= {}
	    
			def self.has_model!
				@@has_models[self] = true
			end
			
			def self.has_model?
				@@has_models[self]
			end
			
			def self.find_or_create_model_class(namespace)
				 if (namespace.constants.include? @@model_class_name[self])
						return namespace.const_get(@@model_class_name[self])
  			 end

				# not exist in the target namespace, duplicate it from the App namespace
				model =  namespace.const_set(@@model_class_name[self], Class.new(::App.const_get(@@model_class_name[self])))
				model.const_set('NAMESPACE',namespace)
				return model
			end
			
			def self.build_model(namespace, schema_element)
				identifier = schema_element.hex_guid
				preferences = schema_element.prefs #load prefs
				preferences = preferences.dup if preferences
				model_klass = namespace.const_set("#{@@model_class_name[self]}#{identifier}", 
																Class.new(self.find_or_create_model_class(namespace)))

				# set class variables
				model_klass.const_set('NAME', schema_element[:name].freeze)
				model_klass.const_set('IDENTIFIER', identifier.freeze)
				model_klass.const_set('PREFS', preferences.freeze)
				model_klass.const_set('SCHEMA', "%016x" % schema_element[:schema].freeze)


				
				# setup model iheritance
				model_klass.set_inheritance! if model_klass.respond_to?(:set_inheritance!)
				if (model_klass.respond_to?(:before_create))
					model_klass.class_eval do				
						# set the STI key to the proper kind
						before_create :set_sti_key
						def set_sti_key
							self[:kind] = self.class::IDENTIFIER.to_i(16)
						end
					end
				end
				

				
				return model_klass
			end
			
			def self.set_extras_for_model(namespace, schema_element)
				model_klass = namespace.const_get("#{@@model_class_name[self]}#{schema_element.hex_guid()}")
				
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
				@@schema_elements_types[self] = symbol.to_s
			end
			
			##
			# Register the schema element for parsing tags as the given symbol
			#
			def self.register_parser_for(symbol)
			  SchemaLoader.register_parser(symbol, self)
		  end
		  
		  ##
		  # accessor for @@should_set_parent
		  #
		  def self.set_parent?
		    @@should_set_parent[self]
		  end
		  
		  ##
		  # sets the @@should_set_parent to true
		  #
		  def self.set_parent!
		    @@should_set_parent[self] = true
	    end
	    
	    ##
	    # Parse the given xml node. can be overriden by subclasses
	    #
	    # @param [SchemaElement, Schema] parent_element the element which children
	    #                                we parse
	    #
	    # @param [LibXML::XML::Node] xml_node the xml node we parse
	    # 
	    # @param [Schema] schema The schema object
	    #
	    # @overrideable
	    #
	    def self.parse(parent_element,xml_node, schema)
        xml_node.children.each_with_index do |element_node, position|
          element = schema["%016x" % element_node['id'].to_i(16)]
          element ||= SchemaElement.new(:type => @@schema_elements_types[self])
          element[:guid] = element_node['id'].to_i(16) if element.new?
          element[:name] = element_node['name']
          element[:position] = position
          
          self.extra_parsing(element,
                             element_node,
                             position,
                             parent_element,
                             schema) if self.respond_to? :extra_parsing
          
          if self.respond_to? :dont_parse_children
            yield nil,nil
          else
            yield element, element_node
          end
        end
	    end
	    
	    
		end
	end
end