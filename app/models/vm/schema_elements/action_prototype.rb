module VM
	module SchemaElementTypes
		class ActionPrototypeSchemaElementType < AbstractSchemaElementType
			register_parser_for 	:prototype
			
			PARSERS = {
			  'param' => :parse_param,
			  'return'  => :parse_return
			}
			
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
	      prefs['prototype'] = parse_prototype(xml_node.children)
        
        parent_element.prefs = prefs
        yield nil,nil
	    end
	
	
	    ##
	    # Parses a list of xml nodes as an 
	    # 
	    # @param [Array[LibXML::XML::Node]] xml_nodes item xml nodes
	    # 
	    # @return [Hash] parsed prefs hash
	    def self.parse_prototype(xml_nodes)
	      return {} if xml_nodes.empty?
        hash = {:params => [], :returns => []}
        xml_nodes.each do |node|
          if node.name == 'block'
            hash[:block] = parse_prototype(node.children)
            next 
          end
          hash[(node.name + 's').to_sym] << {node['name'].to_sym => node['type']}
        end
        
        return hash
	    end
		end
	end
end
