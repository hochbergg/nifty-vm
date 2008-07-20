# = Schema Class 
# controls the reinstansiating of the schema, importing and exporting and etc
#

module VM
	class Schema
		@@generated = []
	
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
		
		def self.models
			self.load_klasses
		end
		
		# generate models from the loaded schema
		def self.instansiate
	 		@@generated = @@base_classes.collect{|klass| klass.build_models}.flatten
		end
		
		def self.load!
			
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
		
		def self.unload!
			@@generated.each do |klass|
				App.send(:remove_const, klass.to_s.split('::').last.to_sym)
			end
			@@generated = []
		end
	end
end