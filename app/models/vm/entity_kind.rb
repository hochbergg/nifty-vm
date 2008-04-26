#  = EntityKind
#
# Generates Entity Classes 
#


require 'model_build_tools'
require 'preferences_tools'

module VM
	class EntityKind < ::Sequel::Model
		include ModelBuildTools
		include PreferencesTools
		
		# assoc
		def field_kinds
			FieldKind.filter(:entity_kind_id => self.id)
		end
		
		def fieldlet_kinds
			FieldletKind.filter(:field_kind_id => field_kinds.map(:id))
		end
		
	
		def build_model_extention
			<<-CLASS_DEF
			def self.field_kinds
				[#{field_kinds.map(:id).collect{|x| "Field#{x}"}.join(',')}]
			end
			
			def self.fieldlet_kind_ids
				[#{fieldlet_kinds.map(:id).join(',')}]
			end
			
			def display_lambda
				
			end
			CLASS_DEF
		end
		
	end
end