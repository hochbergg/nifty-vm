require 'rexml/document'

module VM
	class SchemaLoader
		def initialize(schema_path)
			@document = REXML::Document.new(File.read(schema_path).gsub("\n",'').gsub("\t",''), {:compress_whitespace => :all})
			@schema_xml = @document.root
			@schema_guid = @schema_xml.attributes['id'].to_i(16)
			@entities_xml		 = @schema_xml.elements['entities'] 	|| []
			@pages_xml		 	 = @schema_xml.elements['pages']			|| []
			@lists_xml		 	 = @schema_xml.elements['lists']			|| []
			@filters_xml	 	 = @schema_xml.elements['filters']		|| []
			
			@entities  = []
			@fields 	 = []
			@fieldlets = []
			@pages 		 = []
			@lists 		 = []
			@filters 	 = []
			
			@new = true # the default is new
		end
		
		# read the schema xml document
		#
		def parse!
			@schema = Schema.find(:guid => @schema_guid) || Schema.new(:name => @schema_xml.attributes['name'])
			@new = @schema.new?
			
			@schema.guid = @schema_guid if @new
			@schema.prefs = parse_preferences_items(@schema_xml.elements['preferences'])
			@schema.load_schema_elements()
			
			
			@entities = parse_elements(@entities_xml, 'entity') do |entity, entity_xml|
				@fields.concat(parse_elements(entity_xml.elements['fields'], 'field', entity.values[:guid]) do |field, field_xml|
					@fieldlets.concat parse_elements(field_xml.elements['fieldlets'], 'fieldlet', field.values[:guid])
				end)
			end
					
		end
		
		##
		# Unload the current schema if it's not new
		#
		def unload!
		  return if @schema.new?
		  @schema.unload!
	  end
		
		def parse_elements(xml_elements,element_type,  parent_guid = nil, &block)
			elements = []
			i = 0
			xml_elements.each_element(element_type){|e| elements << parse_element(e, element_type,parent_guid,i += 1, &block)}
			return elements
		end
		
		def parse_element(xml_element, element_type,  parent_guid =nil,position = nil, &block)
			guid = xml_element.attributes['id'].to_i(16)
			name = xml_element.attributes['name']
			preferences = parse_preferences_items(xml_element.elements['preferences'])
			
			element = @schema["%016x" % guid] || SchemaElement.new(:type => element_type)
			if element.new? # not in the schema, we need to create one
				element.schema = @schema_guid
				element.guid 	 = guid
			end
			
			element.set(:name => name) # set the name
			element.set(:parent_guid => parent_guid) if parent_guid
			element.set(:position => position) if position
			
			element.prefs = preferences
			block.call(element, xml_element) if block
			return element
		end
		
		def parse_preferences_items(xml_elements)
			hash = {}
			xml_elements.each_element('item') do |element|
				if v = element.text
					hash[element.attributes['key']] = v
				else
					hash[element.attributes['key']] = parse_preferences_items(element)
				end
			end
			return hash
		end
		
		def set_active!
		  @schema[:active] = true
	  end
	  
	  def save!
	    @schema.save_changes
    end
		
		attr_reader :document, :schema, :entities, :fields, :fieldlets, :pages, :lists, :filters
		
		def commit!
			
			
			items = [@schema]
			[@entities,@fields,@fieldlets,@pages,@lists,@filters].each{|i| items.concat(i)}
			
			items.each do |item|
				if item.new?
					item.save
				else
					item.save_changes
				end
			end
		end
		
		def self.load!(xml_path)
			s = SchemaLoader.new(xml_path)
			s.parse!
      s.unload!
			s.commit!
			s.set_active!
			s.save!
			return s.schema
		end
	end
end