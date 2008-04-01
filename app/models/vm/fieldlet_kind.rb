require 'model_build_tools'
require 'preferences_tools'
require 'preload'
require 'js_generate_tools'

module VM
	class FieldletKind < ::Sequel::Model
		include ModelBuildTools
		include PreferencesTools
		include JsGenerateTools
		
		 def build_model_extention
		 	<<-CLASS_DEF	
				# choose fieldlet & options
				include ::Fieldlets::#{self.kind.capitalize}
				
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
Nifty.form.Fieldlet#{self.id} = Ext.extend(Nifty.form.#{self.kind.capitalize}Fieldlet, {
	fieldLabel: '#{self.name}'
})

Ext.reg('Fieldlet#{self.id}', Nifty.form.Fieldlet#{self.id});
			JSDEF
		end
	end
end