module VM
	module SchemaElementTypes
		class ActionDoSchemaElementType < AbstractSchemaElementType
			register_parser_for 	:do

			
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
	      prefs['do'] = ActionParsers::AbstractParser.parse_node(xml_node)
        
        parent_element.prefs = prefs
        yield nil,nil
	    end
	    	    
      
		end
	end
end
