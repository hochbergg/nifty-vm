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
		def duplicant_changed? 
			return false if !self.link_fieldlet.old_entity
			self.link_fieldlet.entity[:id] != self.link_fieldlet.old_entity[:id]
		end
		
		def destroy_duplicates!(duplicant = self.duplicant())
			ns()::Fieldlet.filter(:instance_id => self.instance_id(), 
														:entity_id => duplicant[:id]).delete
		end
		
		def update_duplicates!(instance)
			if duplicant_changed? 
				destroy_duplicates!(self.link_fieldlet.old_entity)
				create_duplicates!(instance)
				return
			end
			set_duplicants_values!(instance)
			@duplicated_fieldlets.each{|f| f.new? ? f.save : f.save_changes}
		end
		
		# creates a set of 
		def create_duplicates!(instance)
			set_duplicants_values!(instance,true) # false for creating duplicates
			@duplicated_fieldlets.each{|f| f.save}
		end
		
		# we want to set the duplicants values
		# returns 
		def set_duplicants_values!(instance, force_create = false)
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
											:instance_id => instance)
				
				# if we're duplicating the link fieldlet, we need to revesrse it on the 
				# duplicated version
				if self.class::LINK_FIELDLET == fieldlet.class::IDENTIFIER
					values.merge!(:int_value => @entity[:id])
				end
				
				# now will create the fieldlet instances
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
		
		
		def duplicants_fieldlet_ids
			self.duplicant_field::FIELDLET_IDS
		end
		
		def duplicant_field
			@duplicant_field ||= self.class::DUPLICATION[self.duplicant.class]
		end
		
		
		def duplicant
			@duplicant ||= self.link_fieldlet.entity
			@duplicant || @old_duplicant
		end
		
		def link_fieldlet
			@fieldlets[self.class::LINK_FIELDLET]
		end
		
		#end InstanceMethods
	
		
	 #end ClassMethods	
	end
end