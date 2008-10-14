module VM
	module SchemaElementTypes
		class StepsSchemaElementType < AbstractSchemaElementType
			register_parser_for 	:steps
			
			
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
	      prefs= parent_element.prefs
        steps = []
        xml_node.children.each do |step|
          steps << {
            :type => step['type'],
            :params => parse_params(step.child.children)
          }
        end
        
        prefs['steps'] = steps 
        parent_element.prefs = prefs
        yield nil,nil
	    end
	    
	    
	    ##
	    # Parse the given xml_nodes as params
	    #
	    # @param [Array[LibXML::XML::Node]]
	    # 
	    def self.parse_params(xml_nodes)
        params = {}
        xml_nodes.each do |param|
          next if !param['name']
          params[param['name']] = param['value']
        end
        
        return params
      end
		end
	end
end
