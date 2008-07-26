require File.join(File.dirname(__FILE__),'..','..','..', 'spec_helper')

describe "Field Loading" do
	before(:all) do
		load_groups_and_schema(:order_customer_product_schema, :entity_loading_fixture)
		@entity = App::Entity.find_with_fieldlets(App::Entity.fixture(:gilad_avidan_customer).pk)
	end
	
	it "should load field instances" do
		@entity.fields.should_not == {}
		
		# at least one instance
		@entity.fields.values.flatten.should_not be_empty
		
		# contact info field should have 2 instances
		contact_info_field = @entity.fields[VM::FieldKind.fixture(:c_contact_fk).pk]
		
		contact_info_field.size.should == 2
		
		# should have 2 fieldlets on each instance
		
		contact_info_field.first.all_fieldlets.size.should == 2
		
	end
	
	it "should set the link fieldlet for duplicated fields" do
		favorite_product_field_instance =
		 				@entity.fields[VM::FieldKind.fixture(:c_favorite_products_fk).pk].first
		
		favorite_product_field_instance.class.duplicated?.should == true
		
		favorite_product_field_instance.link_fieldlet.value.should_not be_nil
	end

end