# must load namespaces
require 'namespaces'
require 'inheritance_mixin'

module App
	class Fieldlet < Sequel::Model
		include InheritanceMixin
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
	
	
	
		def instance_id
			@values[:instance_id] || 0
		end
		
		# represantations:
		
		def to_json
			{:id 					=> self.id,
			 :type				=> "Fieldlet#{self.kind}",
			 :value				=> self.value_to_json,
			 :field_id		=> self.class.field_id,
			 :instance_id => self.instance_id
			 }.to_json
		end
		
		def to_xml(options = {})
		  xml = Builder::XmlMarkup.new(:indent => 2, :margin => 3)
			xml.fieldlet({:id => self.id, :type => "Fieldlet#{self.kind}"}) do |xml|
				xml.tag!(:value,self.value_to_xml, :type => self.value.class)
			end
		end
		
		
		# overrideable
		def value_to_json
			self.value
		end
		
		# overrideable
		def value_to_xml
			self.value
		end
		
		
		# overrideable value methods
		def value
		end
		
		def value=(input)
		end
		
		
		## callbacks
		
		# used mostly by link fieldlet
		def setup_entities_loading_and_callbacks(entities_to_load)
			return entities_to_load
		end
		
		
	end
end
