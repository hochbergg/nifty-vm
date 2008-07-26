require File.join(File.dirname(__FILE__),'..','..','..', 'spec_helper')

describe "Field Manipulation" do
  before(:all) do
		load_groups_and_schema(:order_customer_product_schema, :entity_loading_fixture)
		@entity = App::Entity.find_with_fieldlets(App::Entity.fixture(:gilad_avidan_customer).pk)
	end

	it "should allways create all the fieldlets upon creation" do
		field_class = get_generated_models(VM::FieldletKind, App::Fieldlet, :c_contact_1_flk).field
		@new_field = field_class.create_new_with_fieldlets(@entity, {
			field_class.fieldlet_kind_ids.first => 'twitter'
		})
		
		@new_field.save
		
		App::Fieldlet.filter(:instance_id => @new_field.instance_id).count.should == 2
		
		# cleanup
		@new_field.destroy
	end
	
	it "should save changed fieldlets" do 
		field_instance = @entity.fields[VM::FieldKind.fixture(:c_contact_fk).pk].first 
		fieldlet_to_update = field_instance.all_fieldlets[0]
		fieldlet_to_update.value = 'jabber address'
		field_instance.save
		
		# reload and check for value
		App::Fieldlet[fieldlet_to_update.pk].value.should == 'jabber address'
	end

	it "should delete all the fieldlets upon delete" do
		field_instance = @entity.fields[VM::FieldKind.fixture(:c_contact_fk).pk].first 
		field_instance.destroy
		
		App::Fieldlet.filter(:instance_id => field_instance.instance_id).count.should == 0
	end
	
end