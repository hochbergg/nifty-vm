Dir.glob(Merb.root / 'app'/ 'models' / 'app' / 'field' / '*.rb').each{|f| require f}


module App
  ##
  # = Field
  # Encapsulate field instance and link duplication behavior.
  # Responsible for creating, updating and deleting instances and their linked instances
  #
  # === Usage
	class Field
		include Enumerable	
		include Namespacing
		
		##
		# Constructor
		#
		# @param [App::Entity] entity that the field belongs to
		# @return [App::Field]
		#
		# === Notes
		# * duplicant is for the other side of an optional link. @see Field#duplicant
		def initialize(entity)
			@entity = entity
			@fieldlets = {} 
			@duplicant = nil
		end
		
    ##
    # Push a given fieldlet to this field instance 
    #
    # @param [App::Fieldlet] fieldlet to be pushed
    # @return [App::Fieldlet] the given fieldlet
    #
    # @raise [Exception] if the given fieldlet's field class don't match this
    #                    instance's class
    #
    # === Notes
    # * If the fieldlet have instance_id, it is set for the field instance's instance_id
    #
		def push(fieldlet)
			if (self.class != fieldlet.class::FIELD)
				raise "FieldletKind mismatch: expected #{self.class} but got #{fieldlet.class::FIELD}" 
			end
			
			# set the instance_id
			@instance_id ||= fieldlet[:instance_id]
			@fieldlets[fieldlet.class::IDENTIFIER] = fieldlet
		end
		
		alias :<< :push
		
    ##
    # Each implementation required by the Enumerable mixin
    #
    # @yield a block for iterating on the filedlets in this instance
    # @yieldparam [App::Fieldlet] the currently iterated fieldlet
    #
		def each(&block)
			@fieldlets.values.each(&block)
		end
    
    ##
    # Returns or sets the 64bit instance_id "random"
    #
    # @return [Fixnum] 64bit instnace_id random
    #
    # === Notes
    # * The left side of the number is the current time, the right side is a random number
    #
		def instance_id
			@instance_id ||= ((Time.now.to_f * 1000).to_i << 16) + rand(1024 * 64)
		end
		
		##
		# Checks if this instance is empty or all its fieldlets are new
		#
		# @return [Boolean] true if there are no fieldlets or that non of the fieldlets is new
		#
		def new?
			@fieldlets.empty? || self.all?{|x| x.new?} 
		end
		
		## 
		# Checks if all of the fieldlets have value
		#
		# @return [Boolean] true if all the fieldlets have no value, false otherwise
		def null?
			!self.all?{|x| x.value?}
		end
		
		##
		# Checks this instance is new and all the fieldlets have no value
		#
		# @return [Boolean] true if all the fieldlets have no value and this instance
		#                   is new. otherwise instead
		def clean?
			self.new? && self.null?
		end
		
		
		##
		# Checks if any of the fieldlets is changed
		#
		# @return [Boolean] if one or more fieldlets have changed
		#
		def changed?
			self.any?{|f| !f.changed_columns.empty?}
		end
		
		## 
		# Sets the instance for removel 
		#
		# === Notes
		# * Instances are removed upon save
		#
		def mark_for_removel!
			@remove = true
		end
		
		# should we return this field? 
		# if linked, and have link value => returned. 
		# if not linked, always returned
		def has_return_value?
			return true if !self.class::DUPLICATION
			return false if self.link_fieldlet.value.nil?
			true
		end
		
		##
		# Return all the fieldlets the instance have, existing and new ones
		#
		# @return [Array[App::Fieldlet]] fieldlets of the field instance
		#
		# === Notes
		# * Non exist fieldlets are created
		#
		def all_fieldlets
			self.class::FIELDLET_IDS.collect do |kind_id| 
				@fieldlets[kind_id] || ns()::Fieldlet.get_subclass_by_id(kind_id).new
			end
		end

		
		
		##
		# Saves the field instance
		#
		# @return [Boolean] true if saved, false if not
		# === Notes
		# * If the field is marked for removal, it will be removed @see App::Field#destroy
		# * If the field hasn't change, return false and do nothing
		# * Handles field duplication before saving the field instance
		#
		def save
			return self.destroy() if @remove 
			return false if !self.changed? || self.clean? # if new and null, we don't need to save anything	
			@new = self.new?
			instance = self.instance_id # prepare the instance id
		
			save_duplication!
			
			self.each do |fieldlet|
				fieldlet.instance_id = instance if fieldlet.new?
				# set entity id for the new fieldlets
				fieldlet.entity_id = @entity[:id]
				# save the fieldlets
				fieldlet.save_changes
			end
			@new = false
			
			return true
		end
		
		##
		# Set the duplication 
		#
		# === Notes
		# * If the field is not duplicated, return nil
		# * If the instance is new, call Field#create_duplicates!, else call Field#update_duplicaes!
		def save_duplication!
			# duplication
			if self.class::DUPLICATION
				@new ? create_duplicates!(@instance_id) : update_duplicates!(@instance_id)
			end
		end
		
		
		##
		# Remove the duplicates if the field is duplicated, delete the field instance
		#
		#
		def destroy	
				destroy_duplicates! if self.class::DUPLICATION
				ns()::Fieldlet.filter(:entity_id => @entity[:id], 
															:instance_id => self.instance_id).delete
				
				return true
		end

		
		# = ClassMethods
	
		
    ##
    # Creates new field instance and its fieldlets from the given fieldlets_hash
    # and pushes to the given entity
    #
    # @param [App::Entity] entity the entity to add the field to
    # @param [Hash] new_fieldlets_hash, contains the information for the new fieldlets, 
    # @see Field::create_fieldlets_from_fieldlets_hash
    # 
    # @return [App::Field, Array[App::Fieldlet]] field and fieldlets created
		def self.create_new_with_fieldlets(entity, new_fieldlets_hash)
			fieldlets = create_fieldlets_from_fieldlets_hash(new_fieldlets_hash)
			field_class = fieldlets.first.class::FIELD
			
			# create new field by the field_class
			field = field_class.new(entity)
			
			fieldlets.each{|f| field << f}
			return field, fieldlets # return fields and fieldlets
		end
		
		protected
		##
		# Create new fieldlets from the given fieldlets hash
		#
		# @param [Hash] new_fieldlets_hash, contains the information for the new fieldlets
		# 
		# @return [Array[App::Fieldlet]] the created fieldlets
		#
		def self.create_fieldlets_from_fieldlets_hash(new_fieldlets_hash)
			field_class = nil
			# initialize the fieldlets	
			fieldlets = []
			new_fieldlets_hash.each do |kind,value|
				fieldlet = ns()::Fieldlet.get_subclass_by_id(kind).new
				
				if field_class && (field_class != fieldlet.class::FIELD)
					raise "FieldletKind mismatch: expected #{field_class} but got #{fieldlet.class::FIELD}" 
				end
				
				fieldlet.value = value
				
				field_class ||= fieldlet.class::FIELD
	
				fieldlets << fieldlet # return the fieldlet
			end
			
			return fieldlets
		end
		
		
	end # Field
end # App