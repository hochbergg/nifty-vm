

module App
	class Entity < Sequel::Model
		#
		# accessors
		#
		attr_accessor :fields, :fieldlets, :instances
		
		def init_fieldlets(fieldlets=[])
			fieldlets.each do |fieldlet|
				push_fieldlet_to_field(fieldlet)
    
				@fieldlets[fieldlet[:instance_id]][fieldlet.class::IDENTIFIER] = fieldlet
				@fieldlets_by_type[fieldlet.class::IDENTIFIER] ||= fieldlet
			end
		end
    
		# push fieldlet to a running instance
		def push_fieldlet_to_field(fieldlet)
    
			field = @fields[fieldlet.class::FIELD_ID].last
			if field && field.instance_id == fieldlet[:instance_id]
				return field << fieldlet
			end 
    
			field = fieldlet.class::FIELD.new(self)
			field << fieldlet
    
			@fields[fieldlet.class::FIELD_ID] << field
    
			# set up instances
    
			@instances[fieldlet[:instance_id]] = field
		end
		
		
		## class methods
			
		def self.find_with_fieldlets(*args)
				entities_to_load = {}
			
				ids = convert_ids_and_push_to_entities_to_load!(args,entities_to_load)
				# convert ids to int from hexs ids
			
				
				fieldlets_dataset = ns()::Fieldlet.order(:entity_id, :instance_id).
																					 filter!(:entity_id => ids)
				
				
				fieldlets_for_entities = Hash.new{|hash, key| hash[key] = []}
				
				# Load all the fieldlets, push them to a hash by the entity_id
				fetched_fieldlets = fieldlets_dataset.all
				fetched_fieldlets.each do |fieldlet|
					next if !fieldlet #
					
					fieldlet.extract_callback(:entity_load_callback,entities_to_load)
					
					fieldlets_for_entities[fieldlet[:entity_id]] << fieldlet
				end
				
				entities = fetch_entities_with_callbacks(entities_to_load) do |entity|
					fieldlets = fieldlets_for_entities[entity[:id]]
					next if fieldlets.empty?
	
					entity.init_fieldlets(fieldlets)
				end
				
				return prepere_fetch_result(ids, entities)
		end

		
		def self.fetch_entities_with_callbacks(entities_to_load)
			return [] if entities_to_load.empty?
			
			# fetch from DB
			entities = ns()::Entity.filter(:id => entities_to_load.keys).all
			
			# iterate each loaded entity, run callbacks and push fieldlets
			entities.each do |entity|
				next if !entity #skip nils
				# run callbacks
				if (entities_to_load[entity[:id]])
					entities_to_load[entity[:id]].each{|callback| callback.call(entity)}
				end
				
				yield entity if block_given? 
			end
			
			# return the loaded entities
			return entities
		end
		
		
		protected
		def self.convert_ids_and_push_to_entities_to_load!(args,entities_to_load)
			ids = args.collect{|x| x.to_i(16)}
			
			## setup hash for entities loading and callbacks
			ids.each{|id| entities_to_load.merge!(id => [])}
		end
	
		def self.prepere_fetch_result(ids, entities)
			# return only requested entities
			entities.reject!{|e| !ids.include? e[:id]}
			
			# return nil if there are no results
			return entities = nil if entities.empty?
			
			# return only one entity if the result array size is 1
			return entities.first if entities.size == 1
			
			return entities
		end
	end
end