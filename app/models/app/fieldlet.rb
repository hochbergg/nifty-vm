# must load namespaces
require 'namespaces'
require 'inheritance_mixin'


module App
	class Fieldlet < Sequel::Model
		# = Fieldlet
		#
		# Fieldlets are the basic building blocks of Nifty
		# Every fieldlet holds a tiny piece of data, from a different type:
		# String, Int, Date, Text etc. 
		#
		# Fieldlets classes are genereated by the FieldletKind on schema load
		# 
		# === Fieldlet kinds
		# 
		# The Nifty platform have the ability to use different fieldlet types
		# and write your own fieldlet types
		#
		# fieldlet types are mix-in modules, which are mixed on the generated
		# fieldlet class on schema load
		#
		# Every fieldlet type must implement a set of methods, in order to work
		# with the Nifty platform.
		#
		# For more information, read the WRITING_YOUR_OWN_FIELDLETS_AND_LISTS
		#
		# =======
		
		
		set_schema(:fieldlets) do 
			bigint			:instance_id, :unsigned => true, :null => false
			varchar			:kind, :size => 32
			int					:entity_id, :unsigned => true, :null => false
			int					:int_value
			varchar			:string_value
			text				:text_value
			
			composite_primary_key(:entity_id, :instance_id, :kind)
		end
	
		# Inheritance Mixin - for smart STI
		include InheritanceMixin
	


		# ==== Representations 
		#
		# Every fieldlet must provide to_xml & to_json methods
		# for representing to fieldlet to the client side
		# 

		
		# JSON representation
		# @overrideable
		def to_json
			{:id 					=> self.instance_id,
			 :type				=> self.class::IDENTIFIER,
			 :value				=> self.value_to_json
			 }.to_json
		end
	
		# XML representation
		# @overrideable		
		def to_xml(options = {})
		  xml = Builder::XmlMarkup.new(:indent => 2, :margin => 3)
			xml.fieldlet({:type => self.class::IDENTIFIER}) do |xml|
				xml.tag!(:value,self.value_to_xml, :type => self.value.class)
			end
		end
		
		# ==== Value Representations
		#  
		# value_to_json & value_to_xml can be overrided to provide extra flexability
		# for value representation.
		#
		
		
		# JSON representation
		# @overrideable
		def value_to_json
			self.value
		end
		
		# XML representation
		# @overrideable
		def value_to_xml
			self.value
		end
		
		
		# ==== Value Manipulation
		# Every fieldlet module must implement the value and value= methods, for
		# reading and writing values
		#
		# Fieldlet have 3 data columns: int_value(integer), string_value(varchar), text_value(text)
		# each fieldlet can set those columns, for any use
		#
		# Example:
		#
		# +DateFieldlet+
		#  def value
		#   Time.at(self.int_value)
		#  end
		#  
		#  def value=(value<DateTime>)
		#   int_value = value.to_i
		#  end
		#
		#


		# returns true if any of the value fields has any value
		# used for checking if having any value, without using the getter
		def value?
			[self.int_value, self.text_value, self.string_value].any?{|x| !x.nil?}
		end


		# Value Getter
		# gets the proper value, from the fieldlet row
		# @overrideable
		
		def value
		end
		
		# Value Setter
		# sets the proper value
		# @overrideable
		
		def value=(input)
		end
		
		
		# ==== callbacks
		#
		#
		
		# entity_load_callback
		# 
		# calls for each loaded entity, before the loading the entities
		# 
		#
		# returns a proc{|entities_to_load, loaded_fieldlets|}
		# 
		# * entities_to_load<Hash>:: from entity_id to array of callbacks, 
		# which called upon loading of the entity with the entity_id of the key. the callbacks
		# are from the type proc{|entity|}
		#
		# * loaded_fieldlets<Array>:: of fieldlets which have been loaded
		#
		
		def entity_load_callback
		end
		
		# entity_save_callback
		#
		# calls for each pending for save fieldlet before it being saved
		# returns a proc{|entity, pending_for_save|}
		# 
		# * entity<Entity>:: The entity of the fieldlet
		# * pending_for_save<Array>:: Array of the fieldlets that are pending to be saved
		#
		
		def entity_create_callback
		end
		
		
		def entity_update_callback
		end
	end
end
