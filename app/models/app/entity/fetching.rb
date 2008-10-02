

module App
	class Entity < Sequel::Model
		#
		# accessors
		#
		attr_accessor :fields, :fieldlets, :instances
		
		
		##
		# Setup the fields-fieldlets structure, iterates over the given fieldlets
		# and push them to their corrsponding fields
		#
		# @param [Array[App::Fieldlet]] fieldlets. an array of loaded fieldlets
		#
		# @see Entity.find_with_fieldlets
		#
		def init_fieldlets(fieldlets=[])
			fieldlets.each do |fieldlet|
				@instances[fieldlet[:instance_id]] = @fields.push(fieldlet)
    
				@fieldlets[fieldlet[:instance_id]][fieldlet.class::IDENTIFIER] = fieldlet
				@fieldlets_by_type[fieldlet.class::IDENTIFIER] ||= fieldlet
			end
		end
    
	
		
		## == ClassMethods
		
		
		##
		# Fetch entities by the given ids, and load their fieldlets.
		#
		# @param [String] *args - one or more hex encoded entity ids
		#
		# @return [nil] if no entity found
		# @return [App::Entity] if single entity found
		# @return Array[App::Entity] array of entities if more than one found
		#
		# === Notes
		# * First we load the fieldlets for all the given entity ids 
		# * We load all the entities by the given ids and the linked entities
		# * We return only the requested entities
		#
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

		##
		# Load the entities with the ids from the entities_to_load hash keys
		# for each loaded entity, call the proc given as the hash value
		# and yield the entity
		#
		# @param [Hash{String => Array[Proc]}] entities_to_load 
		# 
		# @yield proc to run on each entity after running the callbacks
		# @yieldparam [App::Entity] 
		#
		# @return [App::Entity] the loaded entities
		#
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
		##
		# Convert the given args from hex to fixnum and push them into the given 
		# entities_to_load hash 
		# 
		# @param [Array[String]] list of entity ids (hex encoded)
		# @param [Hash{Fixnum => Array[Proc]}] hash to push converted ids to
		#
		# @return [Array[Fixnum]] the converted ids
		#
		def self.convert_ids_and_push_to_entities_to_load!(args,entities_to_load)
			ids = args.collect{|x| x.to_i(16)}
			
			## setup hash for entities loading and callbacks
			ids.each{|id| entities_to_load.merge!(id => [])}
		end
	
		
		##
		# Return only the entities that their id is in ids
		# (@see Entity.find_with_fieldlets)
		# 
		# @param [Array[Fixnum]] ids list of entity ids
		# @param [Array[App::Entity]] entities - a list of entities to filter on
		#
		# @return [nil] if no entity found
		# @return [App::Entity] if single entity found
		# @return Array[App::Entity] array of entities if more than one found
		#
		
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