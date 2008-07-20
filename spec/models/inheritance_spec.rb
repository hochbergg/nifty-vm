require File.join(File.dirname(__FILE__),'..', 'spec_helper')

describe "STIInheritance" do

	# do before
	before(:all) do
		load_groups_and_schema(:inheritance_tests)
	end

	it "should determine the class when fetching" do
		ek = VM::EntityKind.fixture(:inheritance_sample_entity_kind)
		
		target_class = get_generated_models(VM::EntityKind, App::Entity, :inheritance_sample_entity_kind)
		target_entity = load_with_inheritance(App::Entity, :inheritance_sample_entity)
		
		target_entity.class.should eql(target_class)
	end
	
	it "should fetch many entities and get different classes" do
		fetched_entities_classes = load_with_inheritance(App::Entity,:inheritance_sample_entity,
																													:inheritance_another_entity).collect{|x| x.class}

		entity_kinds = get_generated_models(VM::EntityKind,App::Entity, 
																	:inheritance_sample_entity_kind,
																	:inheritance_another_entity_kind)
		
		entity_kinds.each do |klass|
			fetched_entities_classes.should include(klass)
		end
	end

end