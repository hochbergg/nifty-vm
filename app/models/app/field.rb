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
		include Namespacing
		
		def initialize(entity)
			@entity = entity
			@fieldlets = {} 
			@duplicant = nil
		end
		
		# push fieldlets
		def push(fieldlet)
			if (self.class != fieldlet.class::FIELD)
				raise "FieldletKind mismatch: expected #{self.class} but got #{fieldlet.class::FIELD}" 
			end
			
			# set the instance_id
			@instance_id ||= fieldlet[:instance_id]
			@fieldlets[fieldlet.class::IDENTIFIER] = fieldlet
		end
		
		alias :<< :push
		
		# for usage with Enumerable mixin
		def each(&block)
			@fieldlets.values.each(&block)
		end

		def instance_id
			@instance_id ||= ((Time.now.to_f * 1000).to_i << 16) + rand(1024 * 64)
		end
		
		def new?
			@fieldlets.empty? || self.all?{|x| x.new?} 
		end
		
		def null?
			!self.all?{|x| x.value?}
		end
		
		def clean?
			self.new? && self.null?
		end
		
		def changed?
			self.any?{|f| !f.changed_columns.empty?}
		end
		
		# schedual for removel on the next save
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
		
		# return all the fieldlets in this field
		def all_fieldlets
			self.class::FIELDLET_IDS.collect do |kind_id| 
				@fieldlets[kind_id] || ns()::Fieldlet.get_subclass_by_id(kind_id).new
			end
		end

		
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
		end
		
		def save_duplication!
			# duplication
			if self.class::DUPLICATION
				@new ? create_duplicates!(@instance_id) : update_duplicates!(@instance_id)
			end
		end
		
		
		def destroy	
				destroy_duplicates! if self.class::DUPLICATION
				ns()::Fieldlet.filter(:entity_id => @entity[:id], 
															:instance_id => self.instance_id).delete
		end

		
		# = ClassMethods
	
		
		# create new field with new fieldlets hash
		def self.create_new_with_fieldlets(entity, new_fieldlets_hash)
			fieldlets = create_fieldlets_from_fieldlets_hash(new_fieldlets_hash)
			field_class = fieldlets.first.class::FIELD
			
			# create new field by the field_class
			field = field_class.new(entity)
			
			fieldlets.each{|f| field << f}
			return field, fieldlets # return fields and fieldlets
		end
		
		protected
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