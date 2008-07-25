require File.join(File.dirname(__FILE__), 'fixtures_helper')
require 'merb-fixtures'
# = InheritanceTests
#
#

fixture_group(:inheritance_tests) do
	sample_entity_kind = fixture_for(VM::EntityKind, :inheritance_sample_entity_kind) do
		self.name = 'SampleEntityKind'
	end
	
	another_entity_kind = fixture_for(VM::EntityKind, :inheritance_another_entity_kind) do
		self.name = 'AntherEntityKind'
	end
	
	fixture_for(App::Entity, :inheritance_sample_entity) do 
		self.kind = sample_entity_kind.pk
		self.display = 'Sample Entity'
	end
	
	fixture_for(App::Entity, :inheritance_another_entity) do 
		self.kind = another_entity_kind.pk
		self.display = 'Another Entity'
	end
	
end