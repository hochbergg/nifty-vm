module VM

  module ActionParsers
    ##
    # = BlockParser
    # Parse <block> elements
    #
    # == XML form: 
    # <block params="first,second">
    #   <action href="test" />
    # </block>
    #
    # == Array form:
    # [:block,[[:action, ..., :test]], [:first, :second]]
    #
    # == Ruby form: 
    # proc do |first, second|
    #   vars[:first] = first
    #   vars[:second] = second
    # 
    #   ns()::Action['test'].new
    #   
    # end
    #
    class BlockParser < AbstractParser
      register :block
      
      ##
      # Parse the node
      #
      # @param [LibXML::XML::Node] xml_node the xml node to parse
      #
      # @return [Array] an array representation of the element
      # @overriden
      def initialize(xml_node)
        return super if !xml_node['params']
        
        params = xml_node['params'].split(',').collect{|p| p.to_sym}
        
        @return = (super << params)
      end
      
      ##
       # convert the given children and extras
       # to ruby code
       #
       # @param [Array, Symbol] children children of the item
       def self.to_ruby(children, extras)
         children = children.collect{|c| parse_ruby_array(c)}
         params = " "
         setter = ""
         if(extras)
           params = " |#{extras.join(',')}|"
           setter = extras.collect{|p| "vars[:#{p}] = #{p}"}.join("\n")
         end
         
         result = ",&proc do#{params}\n#{setter}\n"
         result += children.join("\n")
         result += "\nend"
         return result 
       end
      
    end
  end # ActionParsers
end # VM