require 'libxml'

module VM
  ##
  # = SchemaLoader
  # Loads an xml schema file and parse it
  #
  class SchemaLoader
    @@parsers = {}
    
    attr_reader :schema
    attr_accessor :elements
    
    ##
    # Initialize the schema loader
    #
    # @param [String] xml_path the path of the xml schema file
    #
    def initialize(xml_path)
      LibXML::XML::Parser.default_keep_blanks = false
      @doc = LibXML::XML::Document.file(xml_path)
      @root = @doc.root
      @elements = []
      
      load_or_create_schema!
      unload_current!
      deactivate!
      parse!
      activate!
      commit!
      load!
    end
    
    ##
    # inspect method, to play nice in the terminal
    def inspect
      "<#SchemaLoader: #{"%016x" % @schema.values[:guid]}, elements: #{@elements.size}>"
    end
    
    
    protected
    
    ##
    # Loads the schema object from the DB or create a new empty one
    #
    def load_or_create_schema!
      guid = @root['id'].to_i(16)
      
      @schema = Schema.find(:guid => guid) 
      @schema ||= Schema.new(:name => @root['name'])
      @new = @schema.new? 
      
      @schema.guid = guid if @new
      @schema.name = @root['name']
      @schema.load_schema_elements()
    end
    
    ##
    # Unloads the schema if active
    #
    def unload_current!
      return if @new
      
      @schema.unload! if @schema.values[:active]
    end
    
    ##
    # Parse the schema elements
    #
    def parse!
      parse_children(@root, @schema)
    end
    
    ##
    # Parses the children of the given node, associate them with the given 
    # schema element
    #
    # @param [LibXML::XML::Node] xml_node
    # @param [SchemaElement, Schema] schema_element
    #
    def parse_children(xml_node, schema_element)
      return if !xml_node #skip if no child node is given
      
      children = xml_node.children
      
      children.each do |child|
        parser = @@parsers[child.name.to_sym]
        
        # skip if no parser was found
        if (!parser)
          puts "skipping #{child.name}, no parser was found"
          next
        end
        
        parser.parse(schema_element,child, @schema) do |c_element, c_node|
          if c_element
            c_element[:parent_guid] = schema_element.guid if parser.set_parent?
            c_element[:schema] = @schema.values[:guid]
            parse_children(c_node, c_element)
            @elements << c_element
          end
        end
      end
    end

    ##
    # Commit the schema changes to the DB
    #
    def commit!
      @schema.save_changes
      @elements.each{|e| e.save_changes}
    end
    
    ##
    # Deactivates to current schema
    #
    def deactivate!
      return if @new
      @schema.active = false
      @schema.save_changes
    end
    
    ##
    # Activate the schema
    #
    def activate!
      @schema.active = true
    end
    
    ##
    # Loads the schema
    #
    def load!
     @schema.load! 
    end
    
    
    public
    
    # == Class methods
    ##
    # Register parser class with a given symbol
    # 
    # @param [Symbol] symbol symbol key
    # @param [Class] klass the class to register
    #
    def self.register_parser(symbol, klass)
      @@parsers[symbol] = klass
    end
    
    ##
    # Accessor for @@parsers
    #
    def self.parsers
     @@parsers 
    end
    
  
  end
end