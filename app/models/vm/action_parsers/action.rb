module VM

  module ActionParsers
    ##
    # = ActionParser
    # Parse <action> elements
    #
    # == XML form: 
    # <action href="actionname">
    #   <params>
    #     <param name="param">
    #       <var name="paramvar" />
    #     </param>
    #     <param name="second">
    #       <var name="secondvar" />
    #     </param>
    #   </params>
    #   <block params="block_param,second_block_param">
    #   </block>
    # </action>
    #
    # == Array form:
    # [:acion,[[:params, ...],[:block, ...]], :actionname]
    #
    # == Ruby form: 
    # ns():Action['actioname'].new(vars[:paramvar], 
    #                             vars[:secondvar], 
    #                             &proc do |block_param, second_block_var|
    # ...
    #)
    # 
    #
    class ActionParser < AbstractParser
      register :action
      children 0..2
      
      ##
      # Parse the node
      #
      # @param [LibXML::XML::Node] xml_node the xml node to parse
      #
      # @return [Array] an array representation of the element
      # @overriden
      def initialize(xml_node)
        @return = (super << xml_node['href'].to_sym)
      end
      
      ##
      # convert the given children and extras
      # to ruby code
      #
      # @param [Array, Symbol] children children of the item
      def self.to_ruby(children, extras)
        children = children.collect{|c| parse_ruby_array(c)}
        result = "ns()::Action['#{extras}'].new("
        result += children.join('')
        result += ')'
        return result 
      end
    end
  end # ActionParsers
end # VM