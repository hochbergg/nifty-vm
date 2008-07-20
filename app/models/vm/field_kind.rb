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
		
		
		# assocs
		belongs_to :entity_kind
		has_many :fieldlet_kinds, :order => :position
		
		def entity_kind
			@entity_kind ||= EntityKind[self.entity_kind_id]
		end
		
		def fieldlet_kinds
			@fieldlet_kinds ||= fieldlet_kinds_dataset.all
		end
		
		def fieldlet_kinds_dataset
			FieldletKind.filter(:field_kind_id => self.pk)
		end
		
		def build_model_extention
			
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
						[#{fieldlet_kinds.collect{|x| "Fieldlet#{x.pk}"}.join(', ')}]
					end
					
					def self.fieldlet_kind_ids
						#{fieldlet_kinds.collect{|x| x.pk}.inspect}
					end
					
					#{set_duplication_settings()}
			CLASS_DEF
		end
		
		def set_duplication_settings
 			return nil if self.preferences.nil? || self.prefs[:duplication].nil?

			duplication_hash = self.prefs[:duplication]
			
			<<-DUPLICATION
			def self.duplicated?
				true
			end
			
			def self.duplication_info
				{
					#{duplication_hash[:target_classes].collect{|k,v| "#{k} => #{v}"}.join(',')}
				}
			end
			
			def self.link_fieldlet
				#{duplication_hash[:link_fieldlet]}
			end
			
			DUPLICATION
		end
		
		
			 # generate_js
		def generate_js
			<<-JSDEF
Nifty.fields.field#{self.id} = Ext.extend(Nifty.widgets.FieldPanel, {
	fieldId: '#{self.id}',
	fieldLabel: '#{self.name}',
	fieldlets: [#{self.fieldlet_kinds.collect{|x| "{kind: #{x.pk}}"}.join(',')}]
})
Ext.reg('Field#{self.pk}', Nifty.fields.field#{self.pk});			
JSDEF
		end
		
	end
end
