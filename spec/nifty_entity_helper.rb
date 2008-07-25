# = NiftyEntityHelper
# collection of methods for easy & clean testing of entities

module NiftyEntityHelper
	
	# options: 
	#    :kind_fixtures
	#    :instances_count 
	# 	 :fields_count
	#def fields_should_load_correctly(entity, options = {})
	#	field_instances = entity.fields.values.flatten
	#	
	#	entity.fields.size.should == options[:fields_count]
	#	field_instances.size.should == options[:instances_count]
	#	
	#	
	#	kind_ids = [VM::FieldKind.fixture(*options[:kind_fixtures])].flatten.collect{|x| x.pk}
	#	
	#	entity.fields.each do |field_kind_id, instances|
	#		kind_ids.should include(field_kind_id)
	#			instances.each do |instance|
	#				instance.kind.should == field_kind_id
	#				instance.fieldlets.size.should == instance.class.fieldlet_kinds.size
	#			end
	#		end
	#	end
	#end
	
	#
	# options: 
	# 	:fieldlet_size
	# 	:fieldlet_fixtures
	def verify_entity(entity, options = {})
		entity.should_not be_nil
		flat_fieldlets = entity.fieldlets.values.collect{|x| x.values}.flatten
		
		flat_fieldlets.size.should == options[:fieldlets_size]
		collection_should_have_fixture_value(flat_fieldlets, options[:fieldlet_fixtures])
		
		options[:linked_to_entities] ||= {}
		options[:linked_to_entities].each do |fieldlet_fixture, entity_fixture|
			target_entity = entity.fieldlets[fieldlet_fixture.instance_id][fieldlet_fixture.kind].value
			
			target_entity.values.should == entity_fixture.values
		end
	end
end