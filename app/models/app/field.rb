# = Field
#
#
#
#



module App
	class Field
		include Enumerable
		
		def initialize(entity)
			@entity = entity
			@fieldlets = Hash.new{|hash, key| hash[key] = Fieldlet.get_subclass_by_id(key).new}
			@pushed_fieldlets = {}
		end
		
		# push fieldlets
		def <<(fieldlet)
			@full = true if @pushed_fieldlets[fieldlet.kind]
			@fieldlets[fieldlet.kind] = fieldlet
			@pushed_fieldlets[fieldlet.kind] = true
		end
		
		# for usage with Enumerable mixin
		def each(&block)
			@fieldlets.values.each(&block)
		end
		
		def full?
			@full || @fieldlets.values.size == self.fieldlet_kinds.size
		end
		
		def new?
			@fieldlets.values.empty? || self.all?{|x| x.new?} 
		end
		
		def null?
			!self.all?{|x| x.value?}
		end
		
		def clean?
			self.new? && self.null?
		end
		
		# return all the fieldlets in this field
		def all_fieldlets
			self.class.fieldlet_kind_ids.collect{|kind_id| @fieldlets[kind_id]}
		end
		
		# when updated, and all the fieldlets are null, 
		#we shuold remove this field instance
		def removed?
			!self.new? && self.null? 
		end
		
		def save
			
			
			return false if self.clean? # if new and null, we don't need to save anything
			if self.removed?
				self.each{|fieldlet| fieldlet.destroy} # remove all the fieldlets
				return true
			end
			
			# set the randomized key
			@randomized_instance_id = (Time.now.to_i << 10) + rand(1024) if self.new?
			self.all_fieldlets.each do |fieldlet| 
				fieldlet.instance_id  = @randomized_instance_id if @randomized_instance_id
				# set entity id for the new fieldlets
				fieldlet.entity_id = @entity.pk
				fieldlet.save_changes
			end # save the fieldlets
		end

		def valid?
			return true
			# TODO: validate here
		end

		
		def to_json(*args)
			@fieldlets.to_json(*args)
		end
		
		
	end # Field
end # App