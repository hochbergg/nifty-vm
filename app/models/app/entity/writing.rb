module App
	class Entity < Sequel::Model
		
		##
		# Adds, updates and removes field instances for the entity
		#
		# @param [Hash] instance_hash
		#
		# === instance_hash examples
		# * Updating: {<InstanceID> => {<FieldletKind> => <FieldletValue>}}
		# 						{'80044300905744541' => {'4589dcc19104b5ad' => 'Merb'}}
		# 						{'80044300905278446' => {'2a1f35b7547e73a7' => {x: 12, y: 34}}}
		#
		# * Adding: 	{'new' => {<UniqInstanceID> => {<FieldletKind> => <FieldletValue>}}}
		# * Removing: {'remove' => {<InstanceID> => true}}
		#
		#def instances=(instances_hash)
		#	@fieldlets_by_type ||= {} #for later lambda reference of the new fieldlets
		#	@entities_to_load    = {}
		#	
		#	add_instances!		instances_hash.delete('new')
		#	remove_instances! instances_hash.delete('remove')
		#	update_instances! instances_hash
		#	self.class.fetch_entities_with_callbacks(@entities_to_load)
    #
		#	
		#	return true
		#end
		

		##
		# Adds field instances for the entity
		#
		# @param [Hash] instance_hash
		#
		# === instance_hash examples
		# {<UniqInstanceID> => {<FieldletKind> => <FieldletValue>}}
		# {'80044300905744541' => {'4589dcc19104b5ad' => 'Merb'}}
		#
		#
		# The UniqInstanceID has no real usage, it is only used the group fieldlets
		# from the same instance
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
				  		callback.call(@entities_to_load)
				  	end
				  	
				  	# for later usage with the display generations
				  	@fieldlets_by_type[fieldlet.class::IDENTIFIER] ||= fieldlet
				  end																						
			end
		end
		
		
		#
		# instances_hash = {<instance_id> => <field_id>}
		#

		##
		# Removes field instances for the entity
		#
		# @param [Hash] instance_hash
		#
		# === instance_hash examples
		#  {<InstanceID> => true}
		#  {'80044300905744541' => true}
		#
		def remove_instances!(instances_hash)	
			return if !instances_hash		
			instances_hash.each do |instance, value|
				@instances[instance.to_i].mark_for_removal!
			end
		end
		
		##
		# Updates field instances for the entity
		#
		# @param [Hash] instance_hash
		#
		# === instance_hash examples
		#  {<InstanceID> => {<FieldletKind> => <FieldletValue>}}
		#  {'80044300905744541' => {'4589dcc19104b5ad' => 'Merb'}}
		#  {'80044300905278446' => {'2a1f35b7547e73a7' => {x: 12, y: 34}}}
		#
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
		
	
		##
	 	# Saves the entity and the fieldlets
	 	# sets the display value of the entity based on the fieldlets
		# 
		# @return [Boolean] true if the entity saved correctly, false if the 
		# 	validation Failed
		#
	 	# ==== Notes
	 	# * If no fieldets, saves only the entity
	 	# * If the fieldlets do not validate, don't save and return false
	 	# * Saves entity and fieldlets in a transaction
	 	#
	 	def save_changes
	 		set_display_value()
	 		return super if @fields.empty? # if no fieldlets, save the normal way
	 	  return false if !self.valid?
	 		self.db.transaction do
	 			if(@new)
	 				self.save
	 			else	
	 				super #call for the inherited save action - saves the entity
	 			end
	 			
	 			@fields.save
	 		end
	 		return true
	 	end
	 	
	 	##
		# Sets the 'display' column on the entity row to the evaluated proc
		# stored in the DISPLAY_LAMBDA const of the class
		#
	 	def set_display_value
	 		if self.class::DISPLAY_LAMBDA
	 			self.display = self.class::DISPLAY_LAMBDA.call(@fieldlets_by_type) 
	 		end
	 	end
	 	
	 	##
	 	# Overides the valid? method of Sequel::Model
	 	#
	 	# @return [Boolean] true if the entity is valid
	 	#
	 	def valid? 
	 	  @valid ||= @fields.valid?
 	  end
 	  
 	  ##
 	  # Overides the errors method of Sequel::Model
 	  #
 	  # @return [Array] of errors
 	  def errors
 	    @fields.errors
    end
	 	
	 	
	 	##
		# Generates a random 64bit integer for usage as a primary key for entities
		#
		# @return [Fixnum] 64bit random
		#
	 	def generate_entity_pk
	 		s = ""
	 		8.times{s << rand(256).to_s(16)}
	 		@values[:id] = s.to_i(16) # 64 bits random
	 	end
	 	
	end
end