
# = JsGenerateTools
#
# A set of tools for generating JS code for kinds
#

module JsGenerateTools	
	# Include Hook
	def self.included(base)
		base.send(:include, InstanceMethods)
		base.extend ClassMethods
		
		# include preferences tools
		#base.send(:include, PreferencesTools)
	end
	
	
	

	module InstanceMethods

		# Create model from this Field Kind
		def generate_js
			# will be overriden
		end
		
	end
	
	module ClassMethods

		def generate_all_js
			all.collect{|m| m.generate_js}
		end
		
	end

end