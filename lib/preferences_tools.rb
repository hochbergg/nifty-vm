# = PreferencesTools
# Utilities for handaling, validating and serialize prefernces
module PreferencesTools
	
	# Include Hook
	def self.included(base)
		base.send(:include, InstanceMethods)
		base.extend ClassMethods
		
		# set the transformation of preferences 
		base.send(:serialize, :preferences)
	end
	
	
	

	module InstanceMethods

	end
	
	module ClassMethods
		## Default Prefrences
		
		
	end
	
end