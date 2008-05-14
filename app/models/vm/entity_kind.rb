#  = EntityKind
#
# Generates Entity Classes 
#


require 'model_build_tools'
require 'preferences_tools'
require 'js_generate_tools'


module VM
	class EntityKind < ::Sequel::Model
		# set schema
		set_schema do 
			primary_key :id
			varchar			:name, :size => 255
			text				:preferences
		end

		
		include ModelBuildTools
		include PreferencesTools
		include JsGenerateTools

		
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
		
		def generate_js
<<-JSDEF
Nifty.entities.kinds.push({id: #{self.id}, singleName: '#{self.name}', multiName: '#{self.name}'});

Nifty.panels['Entity#{self.id}'] = {
	subtitle: '#{self.name}',
	title: 'Loading',
	newItemTitle: 'New #{self.name}',
	renderTo: 'main',
	iconCls: 'x-entity-icon-big-#{self.id}',
	items: {xtype: 'tabpanel',
			activeTab: 0,
			defaults: {autoScroll:false},
			items: [
				{xtype: 'panel',
				 layout: 'niftyForm',
				 title: 'Information',
				 items: [#{field_kinds.map(:id).collect{|x| "{xtype: 'Field#{x}'}"}.join(',')}]
				}
			]
	}
};

Nifty.panels['Entity#{self.id}side'] = {
	title: 'Side Panel',
//	items: [Nifty.entities.newEntityButton],
	renderTo: 'side'
};
JSDEF
		end
		
	end
end