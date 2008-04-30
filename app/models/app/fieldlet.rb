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
		
		# Force the dataset - will force the dataset on all the subclasses
		# (so Fieldlet1 will use the `fieldlets` table instead of `fieldlets1`)
		set_dataset self.db[:fieldlets]
		
		# set schema
		
		set_schema do 
			primary_key :id
			int					:kind
			int					:instance_id
			int					:entity_id
			int					:int_value
			varchar			:string_value, :size => 255
			text				:text_value
			
			index [:entity_id, :kind]
			index [:int_value]
			index [:string_value]
			index [:text_value]
		end
	
		# Inheritance Mixin - for smart STI
		include InheritanceMixin
	
	
	
		# accessor for instance_id, defaults to 0
		def instance_id
			@values[:instance_id] || 0
		end
		

		# ==== Representations 
		#
		# Every fieldlet must provide to_xml & to_json methods
		# for representing to fieldlet to the client side
		# 

		
		# JSON representation
		# @overrideable
		def to_json
			{:id 					=> self.id,
			 :type				=> "Fieldlet#{self.kind}",
			 :value				=> self.value_to_json,
			 :field_id		=> self.class.field_id,
			 :instance_id => self.instance_id
			 }.to_json
		end
	
		# XML representation
		# @overrideable		
		def to_xml(options = {})
		  xml = Builder::XmlMarkup.new(:indent => 2, :margin => 3)
			xml.fieldlet({:id => self.id, :type => "Fieldlet#{self.kind}"}) do |xml|
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
		
		
		## callbacks
		
		# used mostly by link fieldlet
		def setup_entities_loading_and_callbacks(entities_to_load)
			return entities_to_load
		end
		
		
	end
end
