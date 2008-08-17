# = PreferencesTools
# Utilities for handaling, validating and serialize prefernces
module PreferencesTools
	
	# Include Hook
	def self.included(base)
		base.send(:include, InstanceMethods)
		base.send(:before_save, :serialize_prefs)
	end
	
	
	

	module InstanceMethods
		def prefs
			@preferences ||= YAML.load(values[:preferences]) if values[:preferences]
			@preferences ||= {}
		end
		
		def prefs=(value)
			@preferences = value
			serialize_prefs()
		end
		
		def serialize_prefs
			self.set(:preferences => @preferences.to_yaml)
		end
	end
end