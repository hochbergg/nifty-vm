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
		

		
		# InstanceMethods
		
			
			def to_xml
		    xml = Builder::XmlMarkup.new(:indent => 2)
				xml.entity({:id => self.id, :type => self.kind}) do |xml|
					[:display, :created_at, :updated_at].each do |att|
						xml.tag!(att, self.send(att), :type => self.send(att).class)
					end
					xml << self.fields_xml
				end
		  end
		
			def fields_xml
				xml = Builder::XmlMarkup.new(:indent => 2)
				xml.fields do |xml|
					self.clean_fields.each do |field_id,instances|
						xml.field(:type => field_id) do |xml|
							instances.each do |instance|
								xml.instance(:id => instance.instance_id) do |xml|
									instance.each do |fieldlet|
										xml << fieldlet.to_xml
									end
								end
							end
						end
					end
				end
			end
			
			def to_json(*args)				
				json_hash = {
					:id => self.id,
					:type => self.kind,
					:display => self.display,
					:created_at => self.created_at,
					:updated_at	=> self.updated_at,
					:fields => self.clean_fields(),
					:schema => self.class::SCHEMA
				}

				return json_hash.to_json
			end
			
			def clean_fields
				fields = {}
				self.fields.each do |key,field_instances|
					fields[key] = field_instances.reject{|x| !x.returned?}
				end
				return fields
			end
		
		# end  InstanceMethods
	end
end


# UGLY monkey patch over here
class Array
	def to_xml
		xml = Builder::XmlMarkup.new(:indent => 2)
		xml.records do |xml|
			self.each do |item|
				xml << item.to_xml
			end
		end
	end
end