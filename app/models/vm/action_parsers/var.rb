module VM

  module ActionParsers
    ##
    # = VarParser
    # Parse <var> elements
    #
    # == XML form: 
    #   <var name="first"/>
    #
    # == Array form:
    # [:var,:first]
    #
    # == Ruby form: 
    # vars[:first]
    # 
    #
    class VarParser < AbstractParser
      register :var
      
      ##
      # Parse the node
      #
      # @param [LibXML::XML::Node] xml_node the xml node to parse
      #
      # @return [Array] an array representation of the element
      # @overriden
      def initialize(xml_node)
        @return =  [:var, xml_node['name'].to_sym]
      end
      
      ##
      # convert the given children and extras
      # to ruby code
      #
      # @param [Array, Symbol] children children of the item
      def self.to_ruby(children, extras)
        return "vars[:#{children}]"
      end
    end
  end # ActionParsers
end # VM