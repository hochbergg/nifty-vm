require 'model_build_tools'
require 'preferences_tools'
require 'preload'
require 'js_generate_tools'

module VM
	class FieldletKind < ::Sequel::Model
		include ModelBuildTools
		include PreferencesTools
		include JsGenerateTools
		
		# set schema
		
		set_schema do 
			primary_key :id
			varchar			:name, :size => 255
			int					:field_kind_id
			int					:position
			text				:preferences
			varchar			:kind, :size => 255
			varchar			:schema, :size => 38
			
			index [:field_kind_id, :position]
			index	:schema
		end	
		
		
		 def build_model_extention
		 	<<-CLASS_DEF	
				# choose fieldlet & options
				include ::Fieldlets::#{self.kind.capitalize}
				
				# set the primary key
				set_primary_key :entity_id, :instance_id, :kind
				
				
				def type
					:#{self.kind}
				end
				
				def self.field
					Field#{self.field_kind_id}
				end
				
				def self.field_id
					#{self.field_kind_id}
				end
		 	CLASS_DEF
		 end
		
		 # generate_js
		def generate_js
			<<-JSDEF
Nifty.fieldlets.Fieldlet#{self.id} = Ext.extend(Nifty.widgets.fieldlets.#{self.kind.capitalize}Fieldlet, {
	editItemOptions: {emptyText: '#{self.name}'}
});
Ext.reg('Fieldlet#{self.id}', Nifty.fieldlets.Fieldlet#{self.id});
JSDEF
		end
	end
end