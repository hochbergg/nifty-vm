# = FieldDuplication
# 
#
#
#
module App
	class Field
		attr_accessor :duplicant
		attr_accessor :old_duplicant
	
		# InstanceMethods
		##
		# Checks if the linked entity has changed, and we need to delete the duplicates
		# and recreate them for the new entity
		#
		# @return [Boolean] true if the duplicant has changed
		def duplicant_changed? 
			return false if !self.link_fieldlet.old_entity
			self.link_fieldlet.entity[:id] != self.link_fieldlet.old_entity[:id]
		end
		
		##
		# Delete the duplicates for the given duplicant
		#
		# @param [App::Entity] duplicant (optional)
		#
		def destroy_duplicates!(duplicant = self.duplicant())
			ns()::Fieldlet.filter(:instance_id => self.instance_id(), 
														:entity_id => duplicant[:id]).delete
		end
		
		##
		# Updates the duplicants for the given field instance
		#
		# @param [Fixnum] instance_id 64bit instance_id to act upon
		#
		# === Notes
		# * If the duplicant entity has changed, we need to delete the currently
		#   duplicated instance from the older linked duplicant, and create new
		#   duplicated instance for the new entity
		#
		# * If the duplicant hasn't changed, we only update the duplicated instance's
		#   fieldlets and call #save_changes @see set_duplicants_values!
		def update_duplicates!(instance_id)
			if duplicant_changed? 
				destroy_duplicates!(self.link_fieldlet.old_entity)
				create_duplicates!(instance_id)
				return
			end
			set_duplicants_values!(instance_id)
			@duplicated_fieldlets.each{|f| f.new? ? f.save : f.save_changes}
		end
		
		##
		# Creates the duplicants for the given field instance
		#
		# @param [Fixnum] instance_id 64bit instance_id to act upon
    #
    #
		def create_duplicates!(instance)
			set_duplicants_values!(instance,true) # true for creating duplicates
			@duplicated_fieldlets.each{|f| f.save}
		end
		
		##
		# Updates the duplicants for the given field instance
		#
		# @param [Fixnum] instance_id 64bit instance_id to act upon
		# @param [Boolean] force_create true for creating fieldlets, false for
		#                  updating
		#
		#
		 
		def set_duplicants_values!(instance_id, force_create = false)
			@duplicated_fieldlets = []
			
			fieldlets = self.all_fieldlets
			target_fieldlet_ids = self.duplicants_fieldlet_ids

			if target_fieldlet_ids.size != fieldlets.size
				raise "duplicated fields should match!!" 
			end
			
			fieldlets.each_with_index do |fieldlet,i|
				next if !fieldlet.value? #skip if the fieldlet is null
			
				# get the original values
				values = fieldlet.values.dup #dup because hashes are mutable
				
				# overide the kind and the entity_id values
				values.merge!(:entity_id => duplicant.pk, 
											:kind => target_fieldlet_ids[i].to_i(16), 
											:instance_id_id => instance_id)
				
				# if we're duplicating the link fieldlet, we need to revesrse it on the 
				# duplicated version
				if self.class::LINK_FIELDLET == fieldlet.class::IDENTIFIER
					values.merge!(:int_value => @entity[:id])
				end
				
				# now will create the fieldlet instance_ids
					if (fieldlet.new? || force_create)
						target_fieldlet = ns()::Fieldlet.new
						target_fieldlet.values.merge!(values)
					else
						target_fieldlet = ns()::Fieldlet.load(values)
					
						target_fieldlet.set_changed_columns(fieldlet.changed_columns)
					end
					@duplicated_fieldlets << target_fieldlet
			end
			
			return @duplicated_fieldlets
		end
		
		
		##
		# Returns a list of fieldlet ids of the mirroring duplicant field
		#
		# @return [Array[String]] the hex encoded fieldlet ids
		#
		def duplicants_fieldlet_ids
			self.duplicant_field::FIELDLET_IDS
		end
		
		##
		# Returns the Field class of the duplicant entity, which mirrors this instance field
		# 
		# @return [Class] the duplicant field class
		#
		#
		def duplicant_field
			@duplicant_field ||= self.class::DUPLICATION[self.duplicant.class]
		end
		
		##
		# Returns the *current* linked entity to this instance
		# The duplicant is the entity to which the link_fieldlet is pointing to *currently*
		#
		# @return [App::Entity] the linked entity
		#
		# === Notes
		# * the @old_duplicant instance variable is filled upon loading of the entity, with the pointed
		#   entity of the link, currently stored in the DB.
		#
		# * if we have no dupliant, we'll use the @old_duplicant
		#
		def duplicant
			@duplicant ||= self.link_fieldlet.entity
			@duplicant || @old_duplicant
		end
		
		##
		# Return the fieldlet with the type that was defined as the link fieldlet of the field
		# link fieldlet connects the field to the other side of the link
		#
		# @return [App::Fieldlet] the linked fieldlet
		#
		def link_fieldlet
			@fieldlets[self.class::LINK_FIELDLET]
		end
		
		#end InstanceMethods

	end
end