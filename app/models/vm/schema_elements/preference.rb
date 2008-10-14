module VM
	module SchemaElementTypes
		class PreferencesSchemaElementType < AbstractSchemaElementType
			register_parser_for 	:preferences
			
			
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
	      parent_element.prefs = parse_preferences_items(xml_node.children)
        
        
          
        yield nil,nil
	    end
	
	
	    ##
	    # Parses a list of xml nodes as an 
	    # 
	    # @param [Array[LibXML::XML::Node]] xml_nodes item xml nodes
	    # 
	    # @return [Hash] parsed prefs hash
	    def self.parse_preferences_items(xml_nodes)
	      prefs = {}
	      
	      xml_nodes.each do |node|
	        if node.child? && node.child.text? 
	          prefs[node['key']] = node.child.to_s
	        else
	          prefs[node['key']] = parse_preferences_items(node.children)
          end
	      end
	    
	      return prefs
	    end
		end
	end
end
