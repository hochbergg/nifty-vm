#
# = String Fieldlet
# 
# Fieldlet modules are used to define fieldlets types 
# They are mixed-in into generated Fieldlet class 
#

module Fieldlets
	module String
		
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
				self.string_value
			end
		
		
			# Value Setter
			# sets the proper value
			def value=(input)
			  self.string_value = input
			end
						
		end # InstanceMethods
		
		
		
		module ClassMethods
		end # ClassMethods
		
	end
end