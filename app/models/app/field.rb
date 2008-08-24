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
			@duplicant = nil
		end
		
		# push fieldlets
		def push(fieldlet)
			# set the randomized_instance_id
			@randomized_instance_id ||= fieldlet.instance_id
			@fieldlets[fieldlet.class::IDENTIFIER] = fieldlet
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
		
		def changed?
			self.any?{|x| !x.changed_columns.empty?}
		end
		
		
		# should we return this field? 
		# if linked, and have link value => returned. 
		# if not linked, always returned
		def returned?
			return true if not self.class::DUPLICATION
			return false if self.link_fieldlet.value.nil?
			true
		end
		
		# return all the fieldlets in this field
		def all_fieldlets
			self.class::FIELDLET_IDS.collect{|kind_id| @fieldlets[kind_id] || Fieldlet.get_subclass_by_id(kind_id).new}
		end

		
		def save
			return false if !self.changed? || self.clean? # if new and null, we don't need to save anything	
			@new = self.new?
			instance = self.instance_id # prepare the instance id
		
			# duplication
			if self.class::DUPLICATION
				@new ? create_duplicates!(instance) : update_duplicates!(instance)
			end
			

			self.all_fieldlets.each do |fieldlet| 
				fieldlet.instance_id  =  instance if fieldlet.new?
				# set entity id for the new fieldlets
				fieldlet.entity_id = @entity.pk
				# save the fieldlets
				fieldlet.save_changes
			end			
			@new = false
		end
		
		
		def destroy
				self.each{|fieldlet| fieldlet.destroy} # remove all the fieldlets
				
				destroy_duplicates! if self.class::DUPLICATION
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
				fieldlet = Fieldlet.get_subclass_by_id(kind).new
				fieldlet.value = value
				
				# verify matching 
				raise "FieldletKind mismatch: expected #{field_class} but got #{fieldlet.class::FIELD}" if field_class && (field_class != fieldlet.class::FIELD)
				field_class ||= fieldlet.class::FIELD
	
				fieldlets << fieldlet # return the fieldlet
			end
			
			# create new field by the field_class
			field = field_class.new(entity)
			
			fieldlets.each{|f| field.push(f)}
			
			return field, fieldlets # return fields and fieldlets
		end
		
		
	end # Field
end # App