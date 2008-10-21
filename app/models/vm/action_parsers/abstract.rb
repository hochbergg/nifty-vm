module VM
  ##
  # = ActionParser
  # Parses an schema element inside 
  #
  #
  module ActionParsers
    class AbstractParser
      @@parsers ||= {}
      @@name ||= {}
      @@children ||= {}

      ## 
      # ruby before, after, and joiner hashes
      @@after  = {}
      @@before = {}
      @@joiner = {}
      
      ##
      # Parse the node
      #
      # @param [LibXML::XML::Node] xml_node the xml node to parse
      #
      # @return [Array] an array representation of the element
      # @overriden
      def initialize(xml_node)
        if @@children[self.class] and !(@@children[self.class] === xml_node.children.size)
          raise "WrongNumberOfChildren"
        end
      
        @return =  [@@name[self.class], 
                  xml_node.children.collect{|node| self.class.parse_node(node)}
                  ]
      end
      
      ##
      # gets the return value for the parsing
      #
      # @return [Array] the parsed node
      def result
        @return
      end


      ##
      # Parse the given xml node using the corresponding parser
      # extracts the node name from the given xml node, and 
      # call to the constructor for the matching parser class
      #
      # @param [LibXML::XML::Node] xml_node the xml node to parse
      def self.parse_node(xml_node)
        parser = @@parsers[xml_node.name.to_sym]
        raise "No parser registerd for #{xml_node.name}" if !parser
        parser.new(xml_node).result
      end



      ##
      # Register the parser 
      # 
      # @param [Symbol] parser_symbol the parser symbol
      def self.register(parser_symbol)
        @@parsers[parser_symbol] = self
        @@name[self] = parser_symbol
      end

      
      ## 
      # Sets the required children number
      #
      # @param [Fixnum, Range] limit  the number of allowed children
      def self.children(limit)
       @@children[self] ||= limit
      end



      ##
      # Parse ruby item array
      # 
      # @param [Array] ruby_array
      #
      # @return [String] ruby code
      def self.parse_ruby_array(ruby_array)
        parser = @@parsers[ruby_array.first]
        raise "no ruby parser was found for #{ruby_array.inspect} " if !parser
        return parser.to_ruby(ruby_array[1], ruby_array[2])
      end
      
      
      ##
      # convert the given children and extras
      # to ruby code
      #
      # @param [Array, Symbol] children children of the item
      def self.to_ruby(children, extras)
        children = children.collect{|c| parse_ruby_array(c)}
        result = @@before[self] || '('
        result += children.join(@@joiner[self] || ',')
        result += @@after[self] || ')'
        return result 
      end
      
      ##
      # Sets the before ruby token for the current parser
      #
      # @param [String] token the before token
      #
      def self.set_before(token)
        @@before[self] = token
      end

      ##
      # Sets the after ruby token for the current parser
      #
      # @param [String] token the after token
      #
      def self.set_after(token)
        @@after[self] = token
      end
      
      ##
      # Sets the joiner ruby token for the current parser
      #
      # @param [String] token the joiner token
      #
      def self.set_joiner(token)
        @@joiner[self] = token
      end
    end
  end # ActionParsers
end # VM