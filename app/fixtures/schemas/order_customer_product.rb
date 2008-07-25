require File.join(File.dirname(__FILE__),'..', 'fixtures_helper')

# = OrderCustomerProductSchema
#
#
fixture_group(:order_customer_product_schema) do
	
	# EntityKinds
	
	order_ek = fixture_for(VM::EntityKind, :order_ek) do
		self.name = 'Order'
	end
	
	customer_ek = fixture_for(VM::EntityKind, :customer_ek) do
		self.name = 'Customer'
	end
	
	product_ek = fixture_for(VM::EntityKind, :product_ek) do 
		self.name = 'Product'
	end
	
	
	# FieldKinds
	
	# Product FieldKinds:

	p_name_fk = fixture_for(VM::FieldKind,:p_name_fk) do 
	    self.entity_kind_id = product_ek.pk
	    self.name = 'Name'
	    self.position = 0
	end
	
	p_sn_fk = fixture_for(VM::FieldKind,:p_sn_fk) do 
			self.entity_kind_id = product_ek.pk
			self.name = 'Serial Number'
			self.position = 1
	end
	
	p_price_fk = fixture_for(VM::FieldKind,:p_price_fk) do 
			self.entity_kind_id = product_ek.pk
			self.name = 'Price'
			self.position = 2
	end
	
	p_favorited_by_customers_fk = fixture_for(VM::FieldKind,:p_favorited_by_customers_fk) do 
			self.entity_kind_id = product_ek.pk
			self.name = 'Favorited By Customers'
			self.position = 3
	end
	

	# Customer FieldKinds

	c_name_fk = fixture_for(VM::FieldKind, :c_name_fk) do 
	    self.entity_kind_id = customer_ek.pk
	    self.name = 'Name'
	    self.position = 0
	end
	
	c_contact_fk = fixture_for(VM::FieldKind, :c_contact_fk) do 
	    self.entity_kind_id = customer_ek.pk
	    self.name = 'Contacts'
	    self.position = 1
	end

	c_favorite_products_fk = fixture_for(VM::FieldKind, :c_favorite_products_fk) do 
	    self.entity_kind_id = customer_ek.pk
	    self.name = 'Favorite Products'
	    self.position = 2
	end

	# Fieldlets
	
	# product fieldlets

	p_name_flk = fixture_for(VM::FieldletKind, :p_name_flk) do
	  self.field_kind_id = p_name_fk.pk
	  self.position =  1 
	  self.name = 'Name'
	  self.kind = 'string'
	end

	p_sn_flk = fixture_for(VM::FieldletKind, :p_sn_flk) do
	  self.field_kind_id = p_sn_fk.pk
	  self.position =  1 
	  self.name = 'Serial Number'
	  self.kind = 'string'
	end

	p_price_flk = fixture_for(VM::FieldletKind, :p_price_flk) do
	  self.field_kind_id = p_price_fk.pk
	  self.position =  1 
	  self.name = 'Price'
	  self.kind = 'string'
	end
	
 	p_favorited_by_customers_flk = fixture_for(VM::FieldletKind, :p_favorited_by_customers_flk) do
		self.field_kind_id = p_favorited_by_customers_fk.pk
		self.position = 1
		self.name = 'Favorited By Customers'
		self.kind = 'link'
	end
	
	p_favorited_by_customers_bought_at_flk = fixture_for(VM::FieldletKind, :p_favorited_by_customers_bought_at_flk) do 
		self.field_kind_id = c_favorite_products_fk.pk
		self.position = 2
		self.name = 'Bought at'
		self.kind = 'string'
	end
	


	# Customer String fieldlets
	c_name_1_flk = fixture_for(VM::FieldletKind, :c_name_1_flk) do 
		self.field_kind_id = c_name_fk.pk
		self.position = 1
		self.name = 'First Name'
		self.kind = 'string'
	end
	
	
	# Customer String fieldlets
	c_name_2_flk = fixture_for(VM::FieldletKind, :c_name_2_flk) do 
		self.field_kind_id = c_name_fk.pk
		self.position = 2
		self.name = 'Middle Name'
		self.kind = 'string'
	end
	
	
	# Customer String fieldlets
	c_name_3_flk = fixture_for(VM::FieldletKind, :c_name_3_flk) do 
		self.field_kind_id = c_name_fk.pk
		self.position = 3
		self.name = 'Last Name'
		self.kind = 'string'
	end

	# ==
	
	c_contact_1_flk = fixture_for(VM::FieldletKind, :c_contact_1_flk) do 
		self.field_kind_id = c_contact_fk.pk
		self.position = 1
		self.name = 'Type'
		self.kind = 'string'
	end
	
	c_contact_2_flk = fixture_for(VM::FieldletKind, :c_contact_2_flk) do 
		self.field_kind_id = c_contact_fk.pk
		self.position = 2
		self.name = 'Contact'
		self.kind = 'string'
	end

	# == 

	c_favorite_product_flk = fixture_for(VM::FieldletKind, :c_favorite_product_flk) do 
		self.field_kind_id = c_favorite_products_fk.pk
		self.position = 1
		self.name = 'Favorite Products'
		self.kind = 'link'
	end
	
	c_favorite_product_bought_at_flk = fixture_for(VM::FieldletKind, :c_favorite_product_bought_at_flk) do 
		self.field_kind_id = c_favorite_products_fk.pk
		self.position = 2
		self.name = 'Bought at'
		self.kind = 'string'
	end
	

	# field duplication
	

	c_favorite_products_fk.prefs[:duplication] = {
			:link_fieldlet => c_favorite_product_flk.target_model,
			:target_classes => {
				product_ek.target_model() => p_favorited_by_customers_fk.target_model()
			}
		}
	c_favorite_products_fk.save
  
	p_favorited_by_customers_fk.prefs[:duplication] = {
			:link_fieldlet => p_favorited_by_customers_flk.target_model,
			:target_classes => {
				customer_ek.target_model() => c_favorite_products_fk.target_model()
			}
		}
	p_favorited_by_customers_fk.save
end