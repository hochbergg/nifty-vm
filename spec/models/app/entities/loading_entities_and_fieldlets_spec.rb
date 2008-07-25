require File.join(File.dirname(__FILE__),'..','..','..', 'spec_helper')

describe "Entity Loading" do
	include NiftyEntityHelper
	# do before
	before(:all) do
		load_groups_and_schema(:order_customer_product_schema, :entity_loading_fixture)
		
		
		@verification_data = {
			:gilad_avidan_customer => {:fieldlets_size => 9, 
																					  :fieldlet_fixtures => [
																																 :ga_c_name_1_flk,
																																 :ga_c_name_2_flk,
																																 :ga_c_name_3_flk,
																																 :ga_c_contact_1_0_flk,
																																 :ga_c_contact_2_0_flk,
																																 :ga_c_contact_1_1_flk,
																																 :ga_c_contact_2_1_flk,
																																 :ga_c_favorite_product_flk,
																																 :ga_c_favorite_product_bought_at_flk
																																],
																						:linked_to_entities => {
																							App::Fieldlet.fixture(:ga_c_favorite_product_flk) => App::Entity.fixture(:iphone_product)
																						}																					
																	},
																
			:macbook_air_product =>  {:fieldlets_size => 3, 
															 						:fieldlet_fixtures => [:mba_p_name_flk,:mba_p_sn_flk,:mba_p_price_flk]}
		}
	end

	it "should load single entity and have the right type" do
		load_with_inheritance(App::Entity, :macbook_air_product).class.should == get_generated_models(VM::EntityKind, App::Entity,:product_ek)
		load_with_inheritance(App::Entity, :shlomi_atar_customer).class.should == get_generated_models(VM::EntityKind, App::Entity,:customer_ek)		
	end
	
	it "should load single entity with all its fieldlets" do
		macbook_air_product = App::Entity.find_with_fieldlets(App::Entity.fixture(:macbook_air_product).pk)
		verify_entity(macbook_air_product, 	@verification_data[:macbook_air_product])
	end
	
	it "should load single entity with linked entities" do
		gilad_avidan_customer = App::Entity.find_with_fieldlets(App::Entity.fixture(:gilad_avidan_customer).pk)
		verify_entity(gilad_avidan_customer, 	@verification_data[:gilad_avidan_customer])
	end
	
	it "should load couple of entities with their fieldlets and linked entities" do
		entities_to_load_pks = App::Entity.fixture(:macbook_air_product, :gilad_avidan_customer).collect{|x| x.pk}
		
		loaded_entities = App::Entity.find_with_fieldlets(*entities_to_load_pks)
		
		loaded_entities.size.should == 2
		
 		macbook_air_product = loaded_entities.find{|x| x.pk == entities_to_load_pks.first}
 		gilad_avidan_customer = loaded_entities.find{|x| x.pk == entities_to_load_pks.last}

		macbook_air_product.should_not be_nil
		gilad_avidan_customer.should_not be_nil
		
		# verify
		verify_entity(gilad_avidan_customer, 	@verification_data[:gilad_avidan_customer])
		verify_entity(macbook_air_product, 	@verification_data[:macbook_air_product])
		
	end
end