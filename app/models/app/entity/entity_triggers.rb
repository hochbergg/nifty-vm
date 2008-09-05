#
# = EntityTriggers
# A module correspond to background proccess calling by predefined
# conditions
#

module App
	class Entity < Sequel::Model
		# Include Hook

			# set the callbacks
		 before_create :set_create_time
		 before_create :generate_entity_pk
		 before_update :set_update_time
			
		
		# InstanceMethods			
			def set_create_time
				@values[:created_at] = Time.now
				set_update_time #set the update time 
			end# simple time callbacks

			def set_update_time
				@values[:updated_at] = Time.now
			end
			
			
		#end InstanceMethods
	end
end