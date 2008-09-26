require 'builder'

#
# = EntityRepresentation
# A module correspond to the representation of entity in diffrent data structures
#
# 
# == Usage
#
# * <Entity>.to_xml => <xml representation of the entity with the fieldlets
# * <Entity>.to_json => {JSON representation of the entity with the fieldlets}
# 

module App
	class Entity < Sequel::Model
		
			
			def to_json(*args)				
				json_hash = {
					:id => "%016x" % @values[:id],
					:type => self.class::IDENTIFIER,
					:display => @values[:display],
					:created_at => @values[:created_at],
					:updated_at	=> @values[:updated_at],
					:fields => self.only_fields_with_return_value(),
					:schema => self.class::SCHEMA
				}

				return json_hash.to_json(*args)
			end
			
			def only_fields_with_return_value
				fields = {}
				self.fields.each do |key,field_instances|
					fields[key] = field_instances.reject{|x| !x.has_return_value?}
				end
				return fields
			end
		
		# end  InstanceMethods
	end
end
