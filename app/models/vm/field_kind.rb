module VM
	class FieldKind < ::Sequel::Model
		include ModelBuildTools
		include PreferencesTools
		include JsGenerateTools
		
		
		# set schema
		
		set_schema do 
			primary_key :id, :unsigned => true
			varchar			:name, :size => 255
			int					:entity_kind_id, :unsigned => true
			int					:position, :unsigned => true
			text				:preferences
			varchar			:schema, :size => 38
			
			index [:entity_kind_id, :position]
			index :schema
		end
		
		
		# assocs
		belongs_to :entity_kind
		has_many :fieldlet_kinds, :order => :position
		
		def entity_kind
			@entity_kind ||= EntityKind[@values[:entity_kind_id]]
		end
		
		def fieldlet_kinds
			@fieldlet_kinds ||= fieldlet_kinds_dataset.all
		end
		
		def fieldlet_kinds_dataset
			FieldletKind.filter(:field_kind_id => @values[:id], :schema => @values[:schema])
		end
		
		def build_model_extention
			
			<<-CLASS_DEF
					def kind
						#{self.id}
					end
					
					def self.kind
						#{self.pk}
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
Nifty.fields.field#{self.id} = Ext.extend(Nifty.widgets.FieldContainer, {
	fieldId: '#{self.id}',
	fieldLabel: '#{self.name}',
	#{self.set_seperator()}
	instanceLayout: #{self.get_instance_layout()}
	
})
Ext.reg('Field#{self.pk}', Nifty.fields.field#{self.pk});			
JSDEF
		end
		
		def get_instance_layout()
			if self.prefs[:instance_layout].nil?
				return "[#{self.fieldlet_kinds.collect{|x| "{kind: #{x.pk}}"}.join(',')}]"
			end
			
			return self.prefs[:instance_layout].to_json
		end
		
		def set_seperator()
			return "" if self.prefs[:seperator].nil?
			return "seperator: #{self.prefs[:seperator]},"
		end
	end
end
