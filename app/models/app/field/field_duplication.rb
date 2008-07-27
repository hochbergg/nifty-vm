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
			return false if not self.link_fieldlet.old_entity
			self.link_fieldlet.entity.pk != self.link_fieldlet.old_entity.pk
		end
		
		def destroy_duplicates!(duplicant = @duplicant)
			Fieldlet.filter(:instance_id => self.instance_id, :entity_id => duplicant.pk).delete
		end
		
		def update_duplicates!
			if duplicant_changed? 
				destroy_duplicates!(self.link_fieldlet.old_entity)
				create_duplicates!
				return
			end
			set_duplicants_values!
			@duplicated_fieldlets.each{|f| f.save_changes}
		end
		
		# creates a set of 
		def create_duplicates!
			set_duplicants_values!(false) # false for creating duplicates
			@duplicated_fieldlets.each{|f| f.save}
		end
		
		# we want to set the duplicants values
		# returns 
		def set_duplicants_values!(update = true)

			@duplicated_fieldlets = []
			
			my_fieldlets = self.all_fieldlets
			target_fieldlet_ids = self.duplicants_fieldlet_ids
			
			raise "duplicated fields should match!!" if target_fieldlet_ids.size != my_fieldlets.size
			
			my_fieldlets.each_with_index do |my_fieldlet,i|
			
				# get the original values
				values = my_fieldlet.values.dup #dup because hashes are mutable
				
				# if we are updating, don't use the original values, we'll set them later
				# so we could use the 'save_changes' method
				if update
					values.reject!{|k,v| my_fieldlet.changed_columns.include? k}
				end
				
				# overide the kind and the entity_id values
				values.merge!(:entity_id => duplicant.pk, :kind => target_fieldlet_ids[i])
				
				# if we're duplicating the link fieldlet, we need to revesrse it on the 
				# duplicated version
				if self.class.link_fieldlet == my_fieldlet.class.inheritance_id
					values.merge!(:int_value => @entity.pk)
				end
				
				# now will create the fieldlet instances
				if update
					target_fieldlet = Fieldlet.load(values)
					
					my_fieldlet.changed_columns.each do |col|
						target_fieldlet[col] = my_fieldlet[col]
					end
					
					@duplicated_fieldlets << target_fieldlet
				else
					# just create new one
					f = Fieldlet.new
					f.values.merge!(values)
					@duplicated_fieldlets << f
				end
			end
			
			return @duplicated_fieldlets
		end
		
		
		def duplicants_fieldlet_ids
			self.duplicant_field.fieldlet_kind_ids
		end
		
		def duplicant_field
			@duplicant_field ||= self.class.duplication_info[self.duplicant.class]
		end
		
		
		def duplicant
			@duplicant ||= self.link_fieldlet.entity
			@duplicant || @old_duplicant
		end
		
		def link_fieldlet
			@fieldlets[self.class.link_fieldlet]
		end
		
		#end InstanceMethods
	
		#ClassMethods
		def self.set_duplication(somthing)
			
		end
		
		# overriden
		def self.link_fieldlet
			return nil if !duplicated? 
			raise "Field.link_fieldlet method must overriden"
		end
		
		# overriden when duplicates
		def self.duplicated?
			#false
		end
		
	 #end ClassMethods	
	end
end