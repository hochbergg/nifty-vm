require 'preferences_tools'

# = ModelBuildTools
#
# A set of tools for rebuilding models
#

module ModelBuildTools	
	# Include Hook
	def self.included(base)
		base.send(:include, InstanceMethods)
		base.extend ClassMethods
		base.dataset.extend DatasetMethods
		
		# include preferences tools
		#base.send(:include, PreferencesTools)
	end
	
	
	

	module InstanceMethods

		# Create model from this Field Kind
		def build_model(namespace = ::App)
				namespace.module_eval generate_model_def
		end
		
		def generate_model_def			
			<<-CLASS_DEF
			class #{regulated_name_with_id} < #{self.class.regulated_name}

				def self.inheritance_id
					#{self.pk}
				end
				
				def self.preferences
					#{(preferences).inspect}
				end

				# set the STI key to the proper kind
				def after_initialize
				  self.set(:kind => #{self.id}) unless (@values[:kind] || @values['kind'])
				end
				
				def self.inherited?
					true
				end
				
				#{build_model_extention if respond_to? :build_model_extention}
								
			end
			CLASS_DEF
		end


		def regulated_name_with_id
			"#{self.class.regulated_name}#{self.id}" if self.class.respond_to?(:regulated_name)
		end
		
		alias :target_model :regulated_name_with_id
		
	end
	
	module DatasetMethods
		
		
		
	end # DatasetMethods
	
	module ClassMethods

		# Find all the rows and generate models. 
		def build_models(filter = nil)
			f = self
			f = f.filter(filter) if filter		
			f.all.each do |item|
				item.build_model
			end
			all_models
		end
		
		# Return all the generated Models 
		# gets them from the app namespace
		def all_models
			select(:id).map(:id).collect do |i|
				::App.const_get("#{regulated_name}#{i}")
			end
		end

		
		# get the name for the model (without the kind)
		# FIXME: UGLY
		def regulated_name
			self.to_s.sub('Kind','').sub('VM::','')
		end
		
		
	end

end