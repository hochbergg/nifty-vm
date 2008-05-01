module VM
	class FieldKind < ::Sequel::Model
		include ModelBuildTools
		include PreferencesTools
		include JsGenerateTools
		
		
		# set schema
		
		set_schema do 
			primary_key :id
			varchar			:name, :size => 255
			int					:entity_kind_id
			int					:position
			text				:preferences
			
			index [:entity_kind_id, :position]
		end
		
		
		# assocs:
		def entity_kind
			EntityKind[self.entity_kind_id]
		end
		
		#def fieldset_kind_id
		#	Fieldset[self.fieldset_kind_id]
		#end
		
		# loads all the fieldlets
		def fieldlet_kinds
			FieldletKind.filter(:field_kind_id => self.id).order(:position)
		end
		
		
		def build_model_extention
			fieldlet_kinds_ids = fieldlet_kinds.map(:id)
			
			<<-CLASS_DEF
					def kind
						#{self.id}
					end
				
					def self.entity
						Entity#{self.entity_kind_id}
					end
					
					def fieldlet_kinds
						self.class.fieldlet_kinds
					end
					
					def self.fieldlet_kinds
						[#{fieldlet_kinds_ids.collect{|x| "Fieldlet#{x}"}.join(', ')}]
					end
					
					def self.fieldlet_kind_ids
						#{fieldlet_kinds_ids.inspect}
					end
			CLASS_DEF
		end
		
			 # generate_js
		def generate_js
			<<-JSDEF
Nifty.fields.field#{self.id} = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: #{self.id},
	title: '#{self.name}',
	fieldlets: [#{self.fieldlet_kinds.map(:id).collect{|x| "{kind: #{x}}"}.join(',')}]
})
Ext.reg('Field#{self.id}', Nifty.fields.field#{self.id});			
JSDEF
		end
		
	end
end
