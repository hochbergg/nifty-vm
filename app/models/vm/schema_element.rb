module VM
	class SchemaElement < Sequel::Model
		include PreferencesTools
		
		TYPES = ['fieldlet','field','entity','page','filter','list'].freeze
		@@element_types = {}
		
		set_schema do
			varchar :schema, :size => 32, :null => false			
			varchar :guid, :size => 32, :null => false
			varchar :parent_guid, :size => 32
			varchar :name, :size => 255
			varchar :type, :size => 40, :null => false
			integer :position, :unsigned => true, :size => 4
			
			text		:preferences
			
			index		[:parent_guid, :position] # index for ordering
			composite_primary_key(:schema, :guid)
		end
		
		
		
		# schema assocc:
		# get from the loaded schemas or load from the DB
		# === Returns
		# * schema<Schema>
		def schema
			@schema ||= Schema.loaded_schemas[@values[:schema]] || Schema.find(:guid => @values[:schema])
		end
		
		# get the parent from the schema or load from the DB		
		# === Returns
		# * parent<SchemaElement>
		def parent
			@parent ||= self.schema[@values[:parent_guid]]# || SchemaElement.find(:schema => @values[:schema], :guid => @values[:parent_guid])
		end
		
		# get all the kids from the schema or load from the DB
		# === Returns
		# * [<SchemaElement>, ...] - Array of kids schema elements
		def kids
			@kids ||= self.schema.kids_of(@values[:guid])# || SchemaElement.filter(:parent_guid => @values[:guid]).all
		end
		
		def kids_with_type(type)
			type = type.to_s
			k = kids()
			return k.find_all{|x| x.values[:type] == type} if k
			return []
		end
		
		def schema_element_type
			@schema_element_type ||= SchemaElement.element_types[@values[:type].to_sym]
		end
		
		def has_model?
			@has_model ||= self.schema_element_type.has_model?
		end
		
		def build_model(namespace = ::App)
			raise "This schema element doesn't generate model!" if !has_model?
			self.schema_element_type.build_model(namespace, self)
		end
		
		def set_extras(namespace = ::App)
			self.schema_element_type.set_extras_for_model(namespace, self)
		end
		
		def model_name
			return false if not has_model?
			@model_name ||= "#{self.schema_element_type.model_class_name}#{@values[:guid]}"			
		end
		
		# get the generated model from the namespace
		def generated(namespace)
			namespace.const_get(self.model_name)
		end
		
		def self.element_types
			@@element_types
		end
		
		def self.register_element_type(symbol, klass)
			@@element_types[symbol] = klass
		end
	end
end

# load schema elements type
Dir.glob(Merb.root / 'app/models/vm/schema_elements/*.rb').each{|f| require f}