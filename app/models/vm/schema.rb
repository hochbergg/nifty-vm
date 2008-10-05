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
		set_primary_key :guid
		
		one_to_many(:schema_elements,
		            :key => :schema,
		            :class => VM::SchemaElement) do |ds|
		              ds.order(:parent_guid, :position)
		            end
		
		before_destroy :unload! # unload before destroying
		after_destroy  :destroy_schema_elements_on_destruction
		
		
		def load_schema_elements
			@elements = {}
			@children_of_element = {}
			return false if self.new?
			self.schema_elements().each do |schema_element|
				self.push_schema_element(schema_element)
			end
		end
		
		def push_schema_element(schema_element)
			hex_guid = schema_element.hex_guid
			parent_hex_guid = schema_element[:parent_guid]
			parent_hex_guid = "%016x" % parent_hex_guid if parent_hex_guid
		
			
			
			
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
			
			@generated = elements.collect{|e| e.build_model(@namespace)}
			elements.each{|e| e.set_extras(@namespace)}
			
			@generated
		end
		
		def setup_namespace
			@namespace = ::App.const_set("Schema#{"%016x" % @values[:guid]}", Module.new)
			@namespace.const_set('SCHEMA', "%016x" % @values[:guid])
		end	
		
		def register_routing
			if self.prefs['routing'] == '*' || !self.prefs['routing'] # catch all
				::App::SCHEMA_ROUTES[:catch_all] = @namespace
				return
			end
			
			
			if self.prefs['routing'] =~ /^\/\w+$/ #directory
				::App::SCHEMA_ROUTES[:directory][self.prefs['routing'].sub('/','')] = @namespace
				return
			end
			
			::App::SCHEMA_ROUTES[:hosts][self.prefs['routing']] = @namespace
		end
		
		def remove_routing
				if self.prefs['routing'] == '*' || !self.prefs['routing'] # catch all
					::App::SCHEMA_ROUTES[:catch_all] = nil
					return
				end

				if self.prefs['routing'] =~ /^\/\w+$/ #directory
					::App::SCHEMA_ROUTES[:directory].delete self.prefs['routing'].sub('/','')
					return
				end

				::App::SCHEMA_ROUTES[:hosts].delete self.prefs['routing']
		end
		
		#def setup_queue
		#	queue = nil
		#	
		#	if queue_options = self.prefs[:queue_options]
		#			queue = NiftyQ::Manager.new(queue_options[:provider], queue_options[:options])
		#	end
		#	
		#	queue ||= NiftyQ::Manager.new(:sequel, {:db => @namespace::Entity.db})
		#	
		#	@namespace.const_set('QUEUE', queue)
		#end
		
		
		def load!
				self.setup_namespace()
				self.load_schema_elements()
				@@loaded_schemas["%016x" % @values[:guid]] = self
				
				self.instansiate()
			
				puts "Loaded Schema #{"%016x" % @values[:guid]} (#{@generated.size} models) => #{self.prefs['routing']}"
				
				self.register_routing()
#				self.setup_queue() 
				@generated
		end

    ##
    # Remove the schema's schema elements after destruction of 
    # the schema
    #
    def destroy_schema_elements_on_destruction
      
    end
	
		attr_accessor :generated
		
		def unload!
			self.remove_routing()
			
			::App.send(:remove_const, "Schema#{"%016x" % @values[:guid]}".to_sym)
			
			@@loaded_schemas.delete("%016x" % @values[:guid])
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