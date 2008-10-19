module VM
	module SchemaElementTypes
		class ActionDoSchemaElementType < AbstractSchemaElementType
			register_parser_for 	:do
			
			
			PARSERS = {
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
	      prefs['do'] = parse_do(xml_node.children)
        
        parent_element.prefs = prefs
        yield nil,nil
	    end
	
	
	    ##
	    # Parses a list of xml nodes as an 
	    # 
	    # @param [Array[LibXML::XML::Node]] xml_nodes item xml nodes
	    # 
	    # @return [Hash] parsed prefs hash
	    def self.parse_do(xml_nodes)
	      return [] if xml_nodes.empty?
        actions = []
        xml_nodes.each do |node|        
          actions << parse_action(node)
        end
        
        return actions
	    end
	    
	    
	    def self.parse_action(xml_node)
	      params_and_block_hash = {}
	      xml_node.children.each do |node|
	        if(node.name == 'params')
            params_and_block_hash['params'] = parse_action_params(node)
          end
          if(node.name == 'do')
            params_and_block_hash['block'] = parse_do(node.children)
          end
	      end
	      
	      action_hash = {xml_node['href'] => params_and_block_hash}
      end
      
      def self.parse_action_params(xml_node)
        params = []
        xml_node.children.each do |param|
          params << {param['name'] => parse_param(param)}
        end
        return params
      end
      
      def self.parse_param(xml_node)
        child = xml_node.children.first
        if child.text?
          return child.content
        else
          return use_parser(child)
        end
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
