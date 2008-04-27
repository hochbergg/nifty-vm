# must load namespaces
require 'namespaces'
require 'inheritance'

module App
	class Fieldlet < Sequel::Model
		set_dataset self.db[:fieldlets]
		include Inheritance
	
	
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
