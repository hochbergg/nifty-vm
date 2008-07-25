require File.join(File.dirname(__FILE__),'..', 'fixtures_helper')
require File.join(File.dirname(__FILE__),'..', 'schemas', 'order_customer_product')

# = EntityLoadingFixture
#
# holds some ready entities & fieldlets for usage with
# the Entity loading tests

fixture_group(:entity_loading_fixture) do
	
	# simple product
	macbook_air_product = fixture_for(App::Entity, :macbook_air_product) do
		self.kind = VM::EntityKind.fixture(:product_ek).pk
		self.display = 'Apple MacBook Air'
	end
	
	# linked product
	wii_product = fixture_for(App::Entity, :wii_product) do
		self.kind = VM::EntityKind.fixture(:product_ek).pk
		self.display = 'Nintendo Wii'
	end
	
	# another linked product
	iphone_product = fixture_for(App::Entity, :iphone_product) do
		self.kind = VM::EntityKind.fixture(:product_ek).pk
		self.display = 'Apple iPhone'
	end
	
	# customers
	
	shlomi_atar_customer = fixture_for(App::Entity, :shlomi_atar_customer) do
		self.kind = VM::EntityKind.fixture(:customer_ek).pk
		self.display = 'Shlomi Atar'
	end
	
	
	gilad_avidan_customer = fixture_for(App::Entity, :gilad_avidan_customer) do
		self.kind = VM::EntityKind.fixture(:customer_ek).pk
		self.display = 'Gilad Avidan'
	end
	
	# fieldlets

	
	
	
# Gilad Avidan
	
	instance_id = (Time.now.to_i << 10) + rand(1024)
	
	fixture_for(App::Fieldlet, :ga_c_name_1_flk) do
		self.kind = VM::FieldletKind.fixture(:c_name_1_flk).pk
		self.entity_id = gilad_avidan_customer.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = 'Gilad'
#		self.text_value = 
	end

	fixture_for(App::Fieldlet, :ga_c_name_2_flk) do
		self.kind = VM::FieldletKind.fixture(:c_name_2_flk).pk
		self.entity_id = gilad_avidan_customer.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = ''
#		self.text_value = 
	end	
	
	fixture_for(App::Fieldlet, :ga_c_name_3_flk) do
		self.kind = VM::FieldletKind.fixture(:c_name_3_flk).pk
		self.entity_id = gilad_avidan_customer.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = 'Avidan'
#		self.text_value = 
	end
	
	

	instance_id = (Time.now.to_i << 10) + rand(1024)

	fixture_for(App::Fieldlet, :ga_c_contact_1_0_flk) do
		self.kind = VM::FieldletKind.fixture(:c_contact_1_flk).pk
		self.entity_id = gilad_avidan_customer.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = 'Email'
#		self.text_value = 
	end

	fixture_for(App::Fieldlet, :ga_c_contact_2_0_flk) do
		self.kind = VM::FieldletKind.fixture(:c_contact_2_flk).pk
		self.entity_id = gilad_avidan_customer.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = 'giladvdn@gmail.com'
#		self.text_value = 
	end		


	instance_id = (Time.now.to_i << 10) + rand(1024)

	fixture_for(App::Fieldlet, :ga_c_contact_1_1_flk) do
		self.kind = VM::FieldletKind.fixture(:c_contact_1_flk).pk
		self.entity_id = gilad_avidan_customer.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = 'Cellphone'
#		self.text_value = 
	end

	fixture_for(App::Fieldlet, :ga_c_contact_2_1_flk) do
		self.kind = VM::FieldletKind.fixture(:c_contact_2_flk).pk
		self.entity_id = gilad_avidan_customer.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = '054-7709111'
#		self.text_value = 
	end		


	instance_id = (Time.now.to_i << 10) + rand(1024)

	fixture_for(App::Fieldlet, :ga_c_favorite_product_flk) do
		self.kind = VM::FieldletKind.fixture(:c_favorite_product_flk).pk
		self.entity_id = gilad_avidan_customer.pk
		self.instance_id = instance_id
		self.int_value = iphone_product.pk
#		self.string_value = ''
#		self.text_value = 
	end

	fixture_for(App::Fieldlet, :ga_c_favorite_product_bought_at_flk) do
		self.kind = VM::FieldletKind.fixture(:c_favorite_product_bought_at_flk).pk
		self.entity_id = gilad_avidan_customer.pk
		self.instance_id = instance_id
#		self.int_value = iphone_product.pk
		self.string_value = 'Apple Store'
#		self.text_value = 
	end




# Shlomi Atar

	instance_id = (Time.now.to_i << 10) + rand(1024)

	fixture_for(App::Fieldlet, :sa_c_name_1_flk) do
		self.kind = VM::FieldletKind.fixture(:c_name_1_flk).pk
		self.entity_id = shlomi_atar_customer.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = 'Shlomi'
#		self.text_value = 
	end

	fixture_for(App::Fieldlet, :sa_c_name_2_flk) do
		self.kind = VM::FieldletKind.fixture(:c_name_2_flk).pk
		self.entity_id = shlomi_atar_customer.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = 'Jackob'
#		self.text_value = 
	end	

	fixture_for(App::Fieldlet, :sa_c_name_3_flk) do
		self.kind = VM::FieldletKind.fixture(:c_name_3_flk).pk
		self.entity_id = shlomi_atar_customer.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = 'Atar'
#		self.text_value = 
	end



	instance_id = (Time.now.to_i << 10) + rand(1024)

	fixture_for(App::Fieldlet, :sa_c_contact_1_flk) do
		self.kind = VM::FieldletKind.fixture(:c_contact_1_flk).pk
		self.entity_id = shlomi_atar_customer.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = 'Email'
#		self.text_value = 
	end

	fixture_for(App::Fieldlet, :sa_c_contact_2_flk) do
		self.kind = VM::FieldletKind.fixture(:c_contact_2_flk).pk
		self.entity_id = shlomi_atar_customer.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = 'shlomiatar@gmail.com'
#		self.text_value = 
	end		


	instance_id = (Time.now.to_i << 10) + rand(1024)

	fixture_for(App::Fieldlet, :sa_c_contact_1_flk) do
		self.kind = VM::FieldletKind.fixture(:c_contact_1_flk).pk
		self.entity_id = shlomi_atar_customer.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = 'Cellphone'
#		self.text_value = 
	end

	fixture_for(App::Fieldlet, :sa_c_contact_2_flk) do
		self.kind = VM::FieldletKind.fixture(:c_contact_2_flk).pk
		self.entity_id = shlomi_atar_customer.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = '050-2644474'
#		self.text_value = 
	end		


	instance_id = (Time.now.to_i << 10) + rand(1024)

	fixture_for(App::Fieldlet, :sa_c_favorite_product_flk) do
		self.kind = VM::FieldletKind.fixture(:c_favorite_product_flk).pk
		self.entity_id = shlomi_atar_customer.pk
		self.instance_id = instance_id
		self.int_value = wii_product.pk
#		self.string_value = ''
#		self.text_value = 
	end

	fixture_for(App::Fieldlet, :sa_c_favorite_product_bought_at_flk) do
		self.kind = VM::FieldletKind.fixture(:c_favorite_product_bought_at_flk).pk
		self.entity_id = shlomi_atar_customer.pk
		self.instance_id = instance_id
#		self.int_value = wii_product.pk
		self.string_value = 'Amazon'
#		self.text_value = 
	end

# Macbook Air

	instance_id = (Time.now.to_i << 10) + rand(1024)

	fixture_for(App::Fieldlet, :mba_p_name_flk) do
		self.kind = VM::FieldletKind.fixture(:p_name_flk).pk
		self.entity_id = macbook_air_product.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = 'MacBook Air'
#		self.text_value = 
	end

	instance_id = (Time.now.to_i << 10) + rand(1024)

	fixture_for(App::Fieldlet, :mba_p_sn_flk) do
		self.kind = VM::FieldletKind.fixture(:p_sn_flk).pk
		self.entity_id = macbook_air_product.pk
		self.instance_id = instance_id
#		self.int_value = 
		self.string_value = '1234-5678'
#		self.text_value = 
	end

 	instance_id = (Time.now.to_i << 10) + rand(1024)

 	fixture_for(App::Fieldlet, :mba_p_price_flk) do
 		self.kind = VM::FieldletKind.fixture(:p_price_flk).pk
 		self.entity_id = macbook_air_product.pk
 		self.instance_id = instance_id
 #		self.int_value = 
 		self.string_value = '$1799'
 #		self.text_value = 
 	end


	# iPhone 8GB

		instance_id = (Time.now.to_i << 10) + rand(1024)

		fixture_for(App::Fieldlet, :iphone_p_name_flk) do
			self.kind = VM::FieldletKind.fixture(:p_name_flk).pk
			self.entity_id = iphone_product.pk
			self.instance_id = instance_id
	#		self.int_value = 
			self.string_value = 'iPhone 3G 8GB'
	#		self.text_value = 
		end

		instance_id = (Time.now.to_i << 10) + rand(1024)

		fixture_for(App::Fieldlet, :iphone_p_sn_flk) do
			self.kind = VM::FieldletKind.fixture(:p_sn_flk).pk
			self.entity_id = iphone_product.pk
			self.instance_id = instance_id
	#		self.int_value = 
			self.string_value = '1234-5678'
	#		self.text_value = 
		end

	 	instance_id = (Time.now.to_i << 10) + rand(1024)

	 	fixture_for(App::Fieldlet, :iphone_p_price_flk) do
	 		self.kind = VM::FieldletKind.fixture(:p_price_flk).pk
	 		self.entity_id = iphone_product.pk
	 		self.instance_id = instance_id
	 #		self.int_value = 
	 		self.string_value = '$599'
	 #		self.text_value = 
	 	end
	
		# duplicant field
		outher_side_fieldlet = App::Fieldlet.fixture(:ga_c_favorite_product_bought_at_flk)

	 	fixture_for(App::Fieldlet, :iphone_p_favorited_by_customers_flk) do
	 		self.kind = VM::FieldletKind.fixture(:p_favorited_by_customers_flk).pk
	 		self.entity_id = iphone_product.pk
	 		self.instance_id = outher_side_fieldlet.instance_id
			self.int_value = outher_side_fieldlet.entity_id
	 #		self.string_value =
	 #		self.text_value = 
	 	end
	
		fixture_for(App::Fieldlet, :iphone_p_favorited_by_customers_bought_at_flk) do
	 		self.kind = VM::FieldletKind.fixture(:p_favorited_by_customers_bought_at_flk).pk
	 		self.entity_id = iphone_product.pk
	 		self.instance_id = outher_side_fieldlet.instance_id
	 #		self.int_value = outher_side_fieldlet.entity_id
	 		self.string_value = outher_side_fieldlet.string_value
	 #		self.text_value = 
	 	end



 # Wii

 	instance_id = (Time.now.to_i << 10) + rand(1024)

 	fixture_for(App::Fieldlet, :wii_p_name_flk) do
 		self.kind = VM::FieldletKind.fixture(:p_name_flk).pk
 		self.entity_id = wii_product.pk
 		self.instance_id = instance_id
 #		self.int_value = 
 		self.string_value = 'Nintendo Wii'
 #		self.text_value = 
 	end

 	instance_id = (Time.now.to_i << 10) + rand(1024)

 	fixture_for(App::Fieldlet, :wii_p_sn_flk) do
 		self.kind = VM::FieldletKind.fixture(:p_sn_flk).pk
 		self.entity_id = wii_product.pk
 		self.instance_id = instance_id
 #		self.int_value = 
 		self.string_value = 'B0009VXBAQ'
 #		self.text_value = 
 	end

  	instance_id = (Time.now.to_i << 10) + rand(1024)

  	fixture_for(App::Fieldlet, :wii_p_price_flk) do
  		self.kind = VM::FieldletKind.fixture(:p_price_flk).pk
  		self.entity_id = wii_product.pk
  		self.instance_id = instance_id
  #		self.int_value = 
  		self.string_value = '$250'
  #		self.text_value = 
  	end

 	# duplicant field
 	outher_side_fieldlet = App::Fieldlet.fixture(:sa_c_favorite_product_bought_at_flk)

  	fixture_for(App::Fieldlet, :wii_p_favorited_by_customers_flk) do
  		self.kind = VM::FieldletKind.fixture(:p_favorited_by_customers_flk).pk
  		self.entity_id = wii_product.pk
  		self.instance_id = outher_side_fieldlet.instance_id
 		self.int_value = outher_side_fieldlet.entity_id
  #		self.string_value =
  #		self.text_value = 
  	end

 	fixture_for(App::Fieldlet, :wii_p_favorited_by_customers_bought_at_flk) do
  		self.kind = VM::FieldletKind.fixture(:p_favorited_by_customers_bought_at_flk).pk
  		self.entity_id = wii_product.pk
  		self.instance_id = outher_side_fieldlet.instance_id
  #		self.int_value = outher_side_fieldlet.entity_id
  		self.string_value = outher_side_fieldlet.string_value
  #		self.text_value = 
  	end


	
end