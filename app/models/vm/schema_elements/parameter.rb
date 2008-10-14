module VM
	module SchemaElementTypes
		class ParameterSchemaElementType < AbstractSchemaElementType
			register_parser_for 	:params
			
			
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
	      prefs = parent_element.prefs
        params = {}
        xml_node.children.each do |param|
          params[param['name']] = {:type => param['type'], 
                                   :default => param['type']
                                  }
        end
        
        prefs['params'] = params 
        parent_element = prefs
        yield nil,nil
	    end

		end
	end
end
