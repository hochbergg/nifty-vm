# = Schema Class 
# controls the reinstansiating of the schema, importing and exporting and etc
#

module VM
	class Schema
	
		# load all the schema from the db
		def self.load_klasses
			# The order of this array will set the order of the instansiation. 
			@@base_classes = [
			# Fieldlets
			VM::FieldletKind,
			
			# Fields
			VM::FieldKind,
			
			# Fieldsets
			#VM::FieldsetKind,
	
			# Actions
			#VM::ActionKind,
	
			#	Aggregators
			#VM::AggregatorKind,
	
			# Lists
			#VM::ListKind, 
			
			VM::EntityKind
			]
			
	
			return @@base_classes
		end
		
		# generate models from the loaded schema
		def self.instansiate
	 		@@generated = @@base_classes.collect{|klass| klass.build_models}.flatten
		end
		
		def self.load
			
				puts "Schema: Loading Schema classes..." 
				self.load_klasses
				puts "Schema: Instansiating Schema..." 
				self.instansiate
			
				puts "Schema: Generated #{@@generated.size} models"
				@@generated
		end
		
		def self.generated_models
			@@generated
		end
	end
end