Dir.glob(Merb.root / 'app'/ 'models' / 'app' / 'field' / '*.rb').each{|f| require f}
# = Field
# The field class 
#
#
#
#


module App
	class Field
		include Enumerable	
		
		def initialize(entity)
			@entity = entity
			@fieldlets = {} 
			@pushed_fieldlets = {}
			@old_duplicant = @duplicant = nil
		end
		
		# push fieldlets
		def push(fieldlet)
			# set the randomized_instance_id
			@randomized_instance_id ||= fieldlet.instance_id
			
			@old_duplicant = fieldlet.entity if self.class.link_fieldlet == fieldlet.class
			@fieldlets[fieldlet.kind] = fieldlet
		end
		
		# for usage with Enumerable mixin
		def each(&block)
			@fieldlets.values.each(&block)
		end

		def instance_id
			@randomized_instance_id ||= (Time.now.to_i << 10) + rand(1024)
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
		
		# when updated, and all the fieldlets are null, 
		#we shuold remove this field instance
		def removed?
			!self.new? && self.null? 
		end
		
		# should we return this field? 
		# if linked, and have link value => returned. 
		# if not linked, always returned
		def returned?
			return true if not self.class.duplicated? 
			return false if self.linked_entity.value.nil?
			true
		end
		
		# return all the fieldlets in this field
		def all_fieldlets
			self.class.fieldlet_kind_ids.collect{|kind_id| @fieldlets[kind_id] || Fieldlet.get_subclass_by_id(kind_id).new}
		end

		
		def save
			return false if self.clean? # if new and null, we don't need to save anything
			if self.removed?
				self.each{|fieldlet| fieldlet.destroy} # remove all the fieldlets
				
				destroy_duplicates! if self.class.duplicated?
				return true
			end
			
			self.all_fieldlets.each do |fieldlet| 
				fieldlet.instance_id  = self.instance_id if fieldlet.new?
				# set entity id for the new fieldlets
				fieldlet.entity_id = @entity.pk
				fieldlet.save_changes
			end # save the fieldlets
			
			# duplication
			if self.class.duplicated?
				self.new? ? create_duplicates! : update_duplicates!
			end
		end

		def valid?
			return true
			# TODO: validate here
		end

		
		def to_json(*args)
			@fieldlets.to_json(*args)
		end
	
	
		# = ClassMethods
	
		
		# create new field with new fieldlets hash
		def self.create_new_with_fieldlets(entity, new_fieldlet_hash)
			field_class = nil
			
			# initialize the fieldlets	
			fieldlets = []
			new_fieldlet_hash.each do |kind,value|
				fieldlet = Fieldlet.get_subclass_by_id(kind.to_i).new
				fieldlet.value = value
				
				# verify matching 
				raise "FieldletKind mismatch: expected #{field_class} but got #{fieldlet.class.field}" if field_class && (field_class != fieldlet.class.field)
				field_class ||= fieldlet.class.field
	
				fieldlets << fieldlet # return the fieldlet
			end
			
			# create new field by the field_class
			field = field_class.new(entity)
			
			fieldlets.each{|f| field.push(f)}
			
			return field
		end
		
	end # Field
end # App