module VM
	class SchemaElement < Sequel::Model
		include PreferencesTools
		
		@@element_types = {}
		
		set_schema do
			bigint  :schema, :unsigned => true, :null => false			
			bigint  :guid,   :unsigned => true, :null => false
			bigint	:parent_guid, :unsigned => true
			varchar :name
			varchar :type, :size => 40, :null => false
			integer :position, :unsigned => true
			
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
		
		# get all the children from the schema or load from the DB
		# === Returns
		# * [<SchemaElement>, ...] - Array of children schema elements
		def children
			@children ||= self.schema.children_of(@values[:guid])# || SchemaElement.filter(:parent_guid => @values[:guid]).all
		end
		
		def children_with_type(type)
			type = type.to_s
			k = children()
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
		
		
		# representation
		def to_json(*args)
			{
				:id => @values[:guid].to_s,
				:name => @values[:name],
				:type => @values[:type],
				:preferences => self.prefs,
				:children => (self.children || []).collect{|x| x.values[:guid].to_s}
			}.to_json(*args)
		end
		
		
	end
end

# load schema elements type
Dir.glob(Merb.root / 'app/models/vm/schema_elements/*.rb').each{|f| require f}