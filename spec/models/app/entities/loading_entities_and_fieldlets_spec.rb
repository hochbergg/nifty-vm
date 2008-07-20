require File.join(File.dirname(__FILE__),'..','..','..', 'spec_helper')

describe "Entity Loading" do

	# do before
	before(:all) do
		load_groups_and_schema(:order_customer_product_schema, :entity_loading_fixture)
	end

	it "should load single entity and have the right type" do
		load_with_inheritance(App::Entity, :macbook_air_product).class.should == get_generated_models(VM::EntityKind, App::Entity,:product_ek)
		load_with_inheritance(App::Entity, :shlomi_atar_customer).class.should == get_generated_models(VM::EntityKind, App::Entity,:customer_ek)		
	end
	
	it "should load single entity with all its fieldlets" do
		macbook_air_product = App::Entity.find_with_fieldlets(App::Entity.fixture(:macbook_air_product).pk)
		
		
	end
	
	it "should load single entity with linked entities"
	
	it "should load couple of entities with their fieldlets"
	
	it "should load couple of entities with their fieldlets and linked entities"
end