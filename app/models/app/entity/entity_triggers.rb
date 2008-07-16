#
# = EntityTriggers
# A module correspond to background proccess calling by predefined
# conditions
#

module App
	module EntityTriggers
		# Include Hook
		def self.included(base)
			base.send(:include, InstanceMethods)
			base.extend(ClassMethods)
			
			# set the callbacks
			base.before_create :set_create_time
			base.before_update :set_update_time
			
		end
		
		module InstanceMethods			
			def set_create_time
				@values[:created_at] = Time.now
				set_update_time #set the update time 
			end# simple time callbacks

			def set_update_time
				@values[:updated_at] = Time.now
			end
		end #InstanceMethods
		
		module ClassMethods
			
		end #ClassMethods
	end
end