# = Schema Class 
# controls the reinstansiating of the schema, importing and exporting and etc
#

module VM
	class Schema < Sequel::Model
		
		set_schema do
			varchar :guid, :size => 38
			varchar :name, :size => 255
			boolean :active, :default => false
			text		:preferences
			# primary key :guid
			index :active
		end
		
		# classes to load
		CLASSES = [VM::FieldletKind, VM::FieldKind, VM::EntityKind].freeze
		
		def models
			@models ||= CLASSES.collect{|c| c.filter(:schema => @values[:guid])}
		end
		
		# generate models from the loaded schema
		def instansiate
	 		@generated = @models.collect{|klass| klass.build_models}.flatten
		end
		
		def load!
			
				puts "Schema: Loading Schema classes..." 
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
			@generated = []
		end
	end
end