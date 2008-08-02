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
		end
		
		def serialize_prefs
			values[:preferences] = @preferences.to_yaml
		end
	end
end