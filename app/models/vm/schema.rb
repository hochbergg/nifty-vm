# = Schema Class 
# controls the reinstansiating of the schema, importing and exporting and etc
#

module VM
	class Schema < Sequel::Model
		@@loaded_schemas = {}
		
		
		set_schema(:nifty_schemas) do
			varchar :guid, :size => 38
			varchar :name, :size => 255
			boolean :active, :default => false
			text		:preferences
			# primary key :guid
			index :active
			composite_primary_key(:guid)
		end
		
		# classes to load
		CLASSES = [VM::FieldletKind, VM::FieldKind, VM::EntityKind].freeze
				
		# generate models from the loaded schema
		def instansiate
	 		@generated = CLASSES.collect{|klass| klass.build_models(:schema => @values[:guid])}.flatten
		end
		
		def load!
			
				puts "Schema: Loading Schema classes..." 
				puts "Schema: Instansiating Schema..." 
				self.instansiate()
			
				puts "Schema: Generated #{@generated.size} models"
				
				@@loaded_schemas[@values[:guid]] = self
				@generated
		end
	
		attr_accessor :generated
		
		def unload!
			@generated.each do |klass|
				App.send(:remove_const, klass.to_s.split('::').last.to_sym)
			end
			
			@@loaded_schemas.delete @values[:guid]
			
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