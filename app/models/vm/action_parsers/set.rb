module VM

  module ActionParsers
    ##
    # = SetParser
    # Parse <set> elements
    #
    # == XML form: 
    # <set name="varname">
    #   <var name="first"/>
    # </set>
    #
    # == Array form:
    # [:set,[:var, :first], :varname]
    #
    # == Ruby form: 
    # vars[:varname] =  (vars[:first])
    # 
    #
    class SetParser < AbstractParser
      register :set
      children 1
      
      ##
      # Parse the node
      #
      # @param [LibXML::XML::Node] xml_node the xml node to parse
      #
      # @return [Array] an array representation of the element
      # @overriden
      def initialize(xml_node)
        @return = (super << xml_node['name'].to_sym)
      end
      
      ##
       # convert the given children and extras
       # to ruby code
       #
       # @param [Array, Symbol] children children of the item
       def self.to_ruby(children, extras)
         children = children.collect{|c| parse_ruby_array(c)}
         result = "vars[:#{extras}] = "
         result += children.join(@joiner[self] || ',')
         return result 
       end
    end
  end # ActionParsers
end # VM