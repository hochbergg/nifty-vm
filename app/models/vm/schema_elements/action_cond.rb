module VM
	module SchemaElementTypes
		class ActionCondSchemaElementType < AbstractSchemaElementType
			register_parser_for 	:cond
			
			PARSERS = {
			  'and' => :parse_simple,
			  'eq'  => :parse_simple,
			  'gt'  => :parse_simple,
			  'lt'  => :parse_simple,
			  'var' => :parse_var,
			  'int' => :parse_int
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
	      prefs['cond'] = parse_cond(xml_node.children)
        
        parent_element.prefs = prefs
        yield nil,nil
	    end
	
	
	    ##
	    # Parses a list of xml nodes as an 
	    # 
	    # @param [Array[LibXML::XML::Node]] xml_nodes item xml nodes
	    # 
	    # @return [Hash] parsed prefs hash
	    def self.parse_cond(xml_nodes)
	      return {} if xml_nodes.empty?
        hash = {}
        xml_nodes.each do |node|        
          hash.merge!(self.use_parser(node))
        end
        
        return hash
	    end
	    
	    
	    def self.use_parser(node)
	      parser = PARSERS[node.name]
         if(!parser)
           puts "skipped #{node.name}"
           return {}
         end
	      key, value = self.send(parser, node)
	      
	      return {key => value}
      end
      
      def self.parse_simple(node)
        key = node.name.to_sym
         value = node.children.collect{|node|
  	        self.use_parser(node)
  	      }
  	    return key,value
  	  end
      
      
      def self.parse_var(node)
	      key = :var
	      value = node['name'].to_sym
        return key,value
      end
	    
	    def self.parse_int(node)
	      key = :int
	      value = node.content.to_i
        return key,value
      end
		end
	end
end
