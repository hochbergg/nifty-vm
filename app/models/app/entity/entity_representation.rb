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
	module EntityRepresentation
		
		# Include Hook
		def self.included(base)
			base.send(:include, InstanceMethods)
		end
		
		
		module InstanceMethods
		
			
			def to_xml
		    xml = Builder::XmlMarkup.new(:indent => 2)
				xml.entity({:id => self.id, :type => "Entity#{self.kind}"}) do |xml|
					[:display, :created_at, :updated_at].each do |att|
						xml.tag!(att, self.send(att), :type => self.send(att).class)
					end
					xml << self.fields_xml if fieldlet_loaded?
				end
		  end
		
			def fields_xml
				xml = Builder::XmlMarkup.new(:indent => 2)
				xml.fields do |xml|
					self.fields.each do |field|
						xml.field(:type => "Field#{field.kind}") do |xml|
							field.instances.each do |id,fieldlets|
								xml.instance(:id => id) do |xml|
									fieldlets.each do |fieldlet|
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
					:type => "Entity#{self.kind}",
					:display => self.display,
					:created_at => self.created_at,
					:updated_at	=> self.updated_at,
					:fields => self.fields.keys.inject({}){|hash, key| hash.merge!(key.to_i => self.fields[key])}
				}

				return json_hash.to_json
			end
		
		end # InstanceMethods
	end
end


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