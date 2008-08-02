require File.join(File.dirname(__FILE__),'..','..','..', 'spec_helper')

describe "Field Duplication" do
  before(:all) do
		load_groups_and_schema(:order_customer_product_schema, :entity_loading_fixture)
		@entity = App::Entity.find_with_fieldlets(App::Entity.fixture(:gilad_avidan_customer).pk)
		@target_entity = App::Entity[App::Entity.fixture(:wii_product).pk]
		@field_class = get_generated_models(VM::FieldletKind, App::Fieldlet, :c_favorite_product_flk).field
		@fieldlet_kinds = {
			:c_favorite_product_flk => VM::FieldletKind.fixture(:c_favorite_product_flk).pk,
			:c_favorite_product_bought_at_flk => VM::FieldletKind.fixture(:c_favorite_product_bought_at_flk).pk
		}
	end

	it "should duplicate the field on creation" do
		new_field = @field_class.create_new_with_fieldlets(@entity, {
			@fieldlet_kinds[:c_favorite_product_flk] => @target_entity.pk,
			@fieldlet_kinds[:c_favorite_product_bought_at_flk] => 'wii store'
		})
		
		# set the entity to the link fieldlet
		
		new_field.find{|fieldlet| fieldlet.kind == 
									  @fieldlet_kinds[:c_favorite_product_flk]}.entity = @target_entity
		
		new_field.save
		

		# duplicated
		App::Fieldlet.filter(:instance_id => new_field.instance_id).count.should == 4
		
		# cleanup
		new_field.destroy
		
		# verify cleanup
		App::Fieldlet.filter(:instance_id => new_field.instance_id).count.should == 0
	end
	
	
	it "should update both sides of the field" do
		first_instance = @entity.fields[@field_class.kind].first
		first_instance.find{|fieldlet| fieldlet.kind == 
									  @fieldlet_kinds[:c_favorite_product_bought_at_flk]}.value = 'my store'
		
		first_instance.save
		
		# verify
		App::Fieldlet.filter(:instance_id => first_instance.instance_id, 
												 :string_value => 'my store').count.should == 2
		
	end

	it "should delete both sides of the field"
	
	it "should delete and recreate the duplicated field if link target changes"
	
	it "should raise an error if the link target don't match the right EntityKind"
	
end