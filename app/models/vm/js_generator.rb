# = JsGenerator Class 
# controls the reinstansiating of the schema, importing and exporting and etc
#

module VM
	class JsGenerator
	
		# load all the schema from the db
		def self.load_klasses
			# The order of this array will set the order of the instansiation. 
			@@base_classes = [
			# Fieldlets
			VM::FieldletKind,
			
			# Fields
			#VM::FieldKind,
			
			# Fieldsets
			#VM::FieldsetKind,
	
			# Actions
			#VM::ActionKind,
	
			#	Aggregators
			#VM::AggregatorKind,
	
			# Links
			#VM::LinkKind, 
	
			# Lists
			#VM::ListKind, 
			
			#VM::EntityKind
			]
			
	
			return @@base_classes
		end
		
		# generate models from the loaded schema
		def self.build
			self.build_fieldlets_types
			self.load_klasses
	 		generated = @@base_classes.collect{|klass| klass.generate_all_js}.flatten
	
			puts "building #{generated.size} js classes"
			File.open(Merb.root / 'public/javascripts/nifty/generated.js', 'w') do |target|
				target.puts generated.join("\n")
			end
			
		end
		
		def self.clean
		end
		
		def self.build_fieldlets_types
			# generate fieldlet
			puts "generating fieldlets js file"
			File.open(Merb.root / 'public/javascripts/nifty/generated_fieldlets.js', 'w') do |target|
				Dir.glob(Merb.root / 'app' / 'fieldlets' / '*.js').each do |file|
					File.open(file, 'r') do |f|
						puts " - compressing #{File.split(file).last}"
						target.puts f.read
					end
				end
			end
		end
	end
end