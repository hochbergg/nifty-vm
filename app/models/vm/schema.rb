require 'preferences_tools'
# = Schema Class 
# controls the reinstansiating of the schema, importing and exporting and etc
#

module VM
	class Schema < Sequel::Model
		include PreferencesTools
		
		@@loaded_schemas 	= {}
		
		set_schema(:nifty_schemas) do
		 	bigint  :guid, :unsigned => true, :null => false
			varchar :name
			boolean :active, :default => false
			text		:preferences
			# primary key :guid
			index :active
			primary_key [:guid]
		end
		
		
		
		def load_schema_elements
			@elements = {}
			@children_of_element = {}
			return false if self.new?
			SchemaElement.filter(:schema => @values[:guid]).order(:parent_guid, :position).all.each do |schema_element|
				self.push_schema_element(schema_element)
			end
		end
		
		def push_schema_element(schema_element)
			hex_guid = schema_element.hex_guid
			parent_hex_guid = schema_element[:parent_guid]
			parent_hex_guid = parent_hex_guid.to_s(16) if parent_hex_guid
			
			parent_hex_guid = "0#{parent_hex_guid}" if parent_hex_guid && parent_hex_guid.size == 15
			
			
			
			@elements[hex_guid] = schema_element
			
			if parent_hex_guid
				@children_of_element[parent_hex_guid] ||= []
				@children_of_element[parent_hex_guid] << schema_element
			end
		end
		
		def children_of(guid)
			@children_of_element[guid]
		end
		
		def [](guid)
			@elements[guid] if @elements
		end
				
		# generate models from the loaded schema
		def instansiate
			elements = @elements.values
			
			@generated = elements.collect{|e| e.build_model()}
			elements.each{|e| e.set_extras()}
			
			@generated
		end
		
		def load!
				puts "Schema: Loading Schema classes..."
				self.load_schema_elements()
				@@loaded_schemas[@values[:guid].to_s(16)] = self
				
				puts "Schema: Instansiating Schema..." 
				self.instansiate()
			
				puts "Schema: Generated #{@generated.size} models"
								
				@generated
		end

	
		attr_accessor :generated
		
		def unload!
			@generated.each do |klass|
				App.send(:remove_const, klass.to_s.split('::').last.to_sym)
			end
			
			@@loaded_schemas.delete @values[:guid].to_s(16)
			
			@generated = []
		end
		
		# load all the active schemas
		def self.load!
			self.filter(:active => true).all.each do |schema|
				schema.load!
			end
		end
		
		def self.unload!
			@@loaded_schemas.values.each do |schema|
				schema.unload!
			end
		end
		
		def self.loaded_schemas
			@@loaded_schemas
		end
				
	end
end