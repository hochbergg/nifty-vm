#
# = String Fieldlet
# 
# Fieldlet modules are used to define fieldlets types 
# They are mixed-in into generated Fieldlet class 
#

module Fieldlets
	module Link
		
		# included hook
		def self.included(base)
				base.send(:include, InstanceMethods)
				base.extend ClassMethods
		end
		
		
		module InstanceMethods
		
		#
		# = Value Manipulation
		# Every fieldlet module must implement the value and value= methods, for
		# reading and writing values
		#
		# Example:
		#
		# +DateFieldlet+
		#  def value
		#   Time.at(int_value)
		#  end
		#  
		#  def value=(value)
		#   int_value = value.to_i
		#  end
		#
		
			# Value Getter
			# gets the proper value, from the fieldlet row
		
			def value
				@entity ||= Entity[self.int_value]
			end
		
		
			# Value Setter
			# sets the proper value
			def value=(input)
			  self.int_value = input
			end
			
			
			def value_to_json
				{:id => self.value.id,
				 :display => self.value.display,	
				 :type => "Entity#{self.kind}"
				}
			end
			
			# performance
			def entity=(entity)
				@entity = entity
			end
			
			# adds the id to the queued entity loader, 
			# with a callback to update the fieldlet with the loaded entity, 
			# once it loads
			def setup_entities_loading_and_callbacks(entities_to_load)
				return entities_to_load	if not self.int_value
				entities_to_load[self.int_value] ||= []
				entities_to_load[self.int_value] << proc{|entity| self.entity = entity}
				return entities_to_load
			end
						
		end # InstanceMethods
		
		
		
		module ClassMethods
		end # ClassMethods
		
	end
end