module App
	class Entity < Sequel::Model
		# Writing related methods
		# 
		#
		
		# Updates the fieldlets and add new fieldlets to the fiedls
		# 
		# ==== Parameters
    # instances_hash<Hash>:: a hash which will used to update the fieldlet hash
		#
		# ==== Example
		#
		# set_fieldlets({5691 => {10 => 'value'}, 'new' => [-1 => {10 => 'value', 11 => 'blalbla'}, -2 => {10 => 'value'}]})
		#
		# 
		#

		# set_fieldlets({'new' => {1 => {'9ae9d4f04db7012bad310014512145e8' => 'nifty'}}})
		# 			Field instance id =^    Fieldlet guid =^					Fieldlet value =^ 
		
		def instances=(instances_hash)
			@fieldlets_by_type ||= {} #for later lambda reference of the new fieldlets
			@entities_to_load    = {}
			
			add_instances!		instances_hash.delete('new')
			remove_instances! instances_hash.delete('remove')
			update_instances! instances_hash
			self.class.fetch_entities_with_callbacks(@entities_to_load)

			
			return true
		end
		
		# create new instances from the given hash
		def add_instances!(instances_hash)
				return if !instances_hash
				instances_hash.each do |uniq_id, fieldlets_hash|
				field, fieldlets = ns()::Field.create_new_with_fieldlets(self, 
																																fieldlets_hash)
				
				@fields[field.class::IDENTIFIER] << field
				
				# iterate fieldlets, execute load callbacks																														
				fieldlets.each do |fieldlet|
					# fetch and call any callback related to deferred loading of 
					# entities
					if callback = fieldlet.entity_create_callback
						callback.call(@entities_to_lad)
					end
					
					# for later usage with the display generations
					@fieldlets_by_type[fieldlet.class::IDENTIFIER] ||= fieldlet
				end																						
			end
		end
		
		
		#
		# instances_hash = {<instance_id> => <field_id>}
		#

		def remove_instances!(instances_hash)	
			return if !instances_hash		
			instances_hash.each do |instance, value|
				@instances[instance.to_i].mark_for_removel!
			end
		end
		
		# instance_hash = {<instance_id> => {<fieldlet_kind> => <value>, ...}}
		def update_instances!(instances_hash)
			return if !instances_hash
			
			instances_hash.each do |instance_id,fieldlets_hash|
				fieldlets_hash.each do |kind, value|
					fieldlet = @fieldlets[instance_id.to_i][kind]						

					if(!fieldlet) # if there is no such fieldlet, create it
						field = @instances[instance_id.to_i]
						raise "BadInstanceIdException"
						fieldlet = ns()::Fieldlet.get_subclass_by_id(kind).new

						field.push(fieldlet)
					end
					
					# set the fieldlet's value
					fieldlet.value = value
					
					# fetch and call any callback related to deferred loading of 
					# entities
					
					if callback = fieldlet.entity_update_callback
						callback.call(@entities_to_load)
					end
				end
			end
		end
		
		
		#
		# a place for improvement
		#
		
			# Saves the entity and the fieldlets
			#
			# ==== Returns
			# <Boolean>:: true if save was successful, false if validation failed 
			#
			# ==== Notes
			# * If no fieldets, saves only the entity
			# * If the fieldlets do not validate, don't save and return false
			# * Saves entity and fieldlets in a transaction
			#
			def save_changes
				set_display_value()
				return super if !@fields # if no fieldlets, save the normal way
				return false if !self.fields.values.all?{|field| field.all?{|instance| instance.valid?}}
				
				self.db.transaction do
					if(@new)
						self.save
					else	
						super #call for the inherited save action - saves the entity
					end
					
					@fields.values.each{|field| field.each{|instance| instance.save}}
				end
				return true
			end
			
			# sets the display value according to the given lambda
			
			def set_display_value
				if self.class::DISPLAY_LAMBDA
					self.display = self.class::DISPLAY_LAMBDA.call(@fieldlets_by_type) 
				end
			end
	
	
			def generate_entity_pk
				s = ""
				8.times{s << rand(256).to_s(16)}
				@values[:id] = s.to_i(16) # 64 bits random
			end
		
	end
end