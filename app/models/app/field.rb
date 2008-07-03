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
			@fieldlets = {} #Hash.new{|hash, key| hash[key] = Fieldlet.get_subclass_by_id(key).new}
			@pushed_fieldlets = {}
		end
		
		# push fieldlets
		def push(fieldlet)
			# set the randomized_instance_id
			@randomized_instance_id ||= fieldlet.instance_id
			
			@fieldlets[fieldlet.kind] = fieldlet
			
		end
		
		# for usage with Enumerable mixin
		def each(&block)
			@fieldlets.values.each(&block)
		end

		def instance_id
			@randomized_instance_id
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
			self.class.fieldlet_kind_ids.collect{|kind_id| @fieldlets[kind_id] || Fieldlet.get_subclass_by_id(kind_id).new}
		end
		
		# when updated, and all the fieldlets are null, 
		#we shuold remove this field instance
		def removed?
			!self.new? && self.null? 
		end
		
		# should we have duplication? 
		def duplicate?
			!@@duplication_options.nil?
		end
		
		def save
			return false if self.clean? # if new and null, we don't need to save anything
			if self.removed?
				self.each{|fieldlet| fieldlet.destroy} # remove all the fieldlets
				return true
			end
			
			# set the randomized key
			@randomized_instance_id ||= (Time.now.to_i << 10) + rand(1024) if self.new?
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
		
		
		## == class methods
		def self.set_duplication(options)
			@@duplication_options = options
		end
		
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
			
			# push fieldlets
			fieldlets.each{|f| field.push(f)}
			
			return field
		end
		
	end # Field
end # App