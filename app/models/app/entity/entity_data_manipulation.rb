# 
# = EntityDataManipulation
# A module which correspond to loading the entities with the fieldlets,
# match them to the fields and etc.
#
# == Loading Entity
# * Loading only the entity, without the fieldlets
# <tt> 
#  Entity[id<Integer>] => <Entity>
# </tt>
#
# * When loading an entity, the STI mechanisem will map it to the corresponding
# 	subclass
# 
# <tt>
#  Entity1.new(:display => 'test').save => <Entity1 {id: 123, kind: 1, display: 'test'}>
#  Entity[123] => <Entity1 {id: 123, kind: 1, display: 'test'}>
# </tt>
#
# * Loading Entity with it's fieldlets 
# <tt> 
#  Entity.find_with_fieldlets(id<Integer>) => <#Entity>
#  <#Entity>.fieldlets => <FieldletHash>
# </tt>
#
# * Loading N entities with their fieldlets
# <tt> 
#  Entity.find_with_fieldlets(id, id) => [<#Entity>, <#Entity>]
# </tt>
#
# * Loading Entity with filtered fieldlets
# <tt> 
#  Entity.find_with_fieldlets(:fieldlets_filter => filter<Hash>,id, id) 
# 							=> [<#Entity>, <#Entity>]
#
#  Entity.find_with_fieldlets(:fieldlets_filter => filter<Hash>,id<Integer>)
#    => <#Entity>
# </tt>
#
#
# * Loading Entity with only specific fieldlet types
# <tt> 
#  Entity.find_with_fieldlets(:fieldlets_filter => {:type => [fieldlet_type<Integer>,...],id, id) 
# 							=> [<#Entity>, <#Entity>]
#
# </tt>
#
#
#
# == Updating or creating entity: (post parameters)
# 	* entity[<fieldlet_id>] = <value> => will set the value of the proper
# 																			 fieldlet (instance_id => 0)
#   * entity[<fieldlet_id>][<instance_id>] = <value> will set the value of the
# 																								  proper fieldlet, with the 
# 																									given instance id
#
# == Saving 
#
# * Saving an entity and all it's fieldlets
# <#Entity>.save 
#
# ===

module App
	class Entity < Sequel::Model

		
		# InstanceMethods			

		
			# sets the fieldlets
			def fieldlets=(value_hash)
				set_fieldlets(value_hash)
			end
			
			
			# used for a cached access to loaded fieldlets. 
			# if non loaded, load them
			def fieldlets
				@fieldlets || init_fieldlets
			end
			
			
			
			def init_fieldlets(fieldlets)
				@fieldlets = {} # set the default value to be hash
				
				fieldlets.each do |fieldlet|
					push_fieldlet_to_field(fieldlet)
				
					@fieldlets[fieldlet.instance_id] ||= {}
					@fieldlets[fieldlet.instance_id][fieldlet.kind] = fieldlet
				end
				
			end
			
			# push fieldlet to a running instance
			def push_fieldlet_to_field(fieldlet)
				field = self.fields[fieldlet.class.field_id].last
				if field && field.instance_id == fieldlet.instance_id
					field.push(fieldlet)
				else
					field = fieldlet.class.field.new(self)
					field.push(fieldlet)
					self.fields[fieldlet.class.field_id] << field
				end
			end
			
			# Updates the fieldlets and add new fieldlets to the fiedls
			# 
			# ==== Parameters
      # fieldlet_hash<Hash>:: a hash which will used to update the fieldlet hash
			#
			# ==== Example
			#
			# set_fieldlets({5691 => {10 => 'value'}, 'new' => [-1 => {10 => 'value', 11 => 'blalbla'}, -2 => {10 => 'value'}]})
			#

			def set_fieldlets(fieldlet_hash)
				entities_to_load = {}
				
				if new_fields_hash = fieldlet_hash['new']
					fieldlet_hash.delete 'new'
				end

				# update
				fieldlet_hash.each do |instance_id,kinds_hash|
					kinds_hash.each do |kind_id, value|
						fieldlet = self.fieldlets[instance_id.to_i][kind_id.to_i]
						fieldlet.value = value
						fieldlet.entity_update_callback.call(entities_to_load,fieldlet_hash) if fieldlet.entity_update_callback
					end
				end
				
				new_fields_hash ||= {}
				new_fields_hash.values.each do |new_field_fieldlets_hash|					
					field = Field.create_new_with_fieldlets(self, new_field_fieldlets_hash)
					
					field.each do |fieldlet|
						fieldlet.entity_create_callback.call(entities_to_load) if fieldlet.entity_create_callback
					end
					self.fields[field.kind] << field 
				end
				
				#load the required entities, and call the callbacks
				entities = Entity.filter(:id => entities_to_load.keys).all
				
				# iterate each loaded entity, run callbacks and push fieldlets
				entities.each do |entity|
					# run callbacks
					if (!entities_to_load[entity.id].empty?)
						entities_to_load[entity.id].each{|callback| callback.call(entity)}
					end
				end
				
				return true
			end
			
			# alias
			alias	:set_fieldlets :fieldlets=

			
			# Accessor for the fields
			# if no fieldls were initialized, initalize the fields
			def fields
				@fields ||= Hash.new{|hash, key| hash[key] = []}
			end
			
			
			# Shortcut for self.class.field_kinds => generated information
			def field_kinds
				self.class.field_kinds
			end
		
			# The display value of the entity
			def display
				@values[:display]
			end
			
			# Saves the entity and the fieldlets
			#
			# ==== Returns
			# <Boolean>:: true if save was successful, false if validation failed 
			#
			# ==== Notes
			# * If no fieldets, saves only the entity
			# * If the fieldlets do not validate, don't save and return false
			# * Saves entity and fieldlets in a transaction
			#
			def save_changes
				set_display_value()
				return super unless @fields # if no fieldlets, save the normal way
				return false unless self.fields.values.all?{|field| field.all?{|instance| instance.valid?}}
				
				self.db.transaction do
					super #call for the inherited save action - saves the entity
					self.fields.values.each{|field| field.each{|instance| instance.save}}
				end
				return true
			end
			
			# sets the display value according to the given lambda
			def set_display_value
				self.display = display_lambda().call(self) if display_lambda()
			end
		
			# will be overriden
			def display_lambda; end
			
		 # end InstanceMethods
		
		# ClassMethods
				
				# Find entities and load their fieldlets by the given ids
				#
				# ==== Parameters
				# args<~to_i/to_hash>:: arguments/options
				#
				# ==== Args
				# options_hash<Hash>(optional):: an options hash
				# id<Integer>:: id of an entity to load 
				# or 
				# id<Integer>, ... :: list of entity ids to load 
				# 
				# ==== Opts (options_hash)
				# :fieldlet_filter<Hash> :: a filter to be applied on the fieldlet set
				#
				#
				# ==== Examples
				#
				# * Loading Entity with it's fieldlets 
				# <tt> 
				#  Entity.find_with_fieldlets(id<Integer>) => <#Entity>
				#  <#Entity>.fieldlets => <FieldletHash>
				# </tt>
				#
				# * Loading N entities with their fieldlets
				# <tt> 
				#  Entity.find_with_fieldlets(id, id) => [<#Entity>, <#Entity>]
				# </tt>
				#
				# * Loading Entity with filtered fieldlets
				# <tt> 
				#  Entity.find_with_fieldlets(:fieldlets_filter => filter<Hash>,id, id) 
				# 							=> [<#Entity>, <#Entity>]
				#
				#  Entity.find_with_fieldlets(:fieldlets_filter => filter<Hash>,id<Integer>)
				#    => <#Entity>
				# </tt>
				#
				#
				# * Loading Entity with only specific fieldlet types
				# <tt> 
				#  Entity.find_with_fieldlets(:fieldlets_filter => {:type => [fieldlet_type<Integer>,...],id, id) 
				# 							=> [<#Entity>, <#Entity>]
				#
				# </tt>
				#
				# ===== Returns
				# <Entity>:: Single entity with its fieldlets loaded
				# [<Entity>, ...]:: Multiple entities with their fieldlets loaded
				# <Nil> :: 	If no result found
				
				def self.find_with_fieldlets(*args)

						options_hash = {}
						
						if args.first.kind_of? Hash
							options_hash = args.first
							args.delete options_hash
						end
						
						# convert ids to int ids
						ids = args.collect{|x| x.to_i}
					
					
						entities_to_load = {}
						## setup hash for entities loading and callbacks
						ids.each{|id| entities_to_load.merge!(id => [])}
						
						fieldlets_set = Fieldlet.order(:instance_id).filter(:entity_id => ids)
						
						# Apply a fieldlets filter if given
						fieldlets_set = fieldlets_set.filter(options_hash[:fieldlets_filter]) if options_hash[:fieldlets_filter]
						
						# load only given fields
						if options_hash[:only_fields]
							fieldlets_field_filter = options_hash[:only_fields].collect do |field_cls| 
								field_cls.fieldlet_kind_ids
							end
							fieldlets_field_filter.uniq!
							
							fieldlets_set.filter(:kind => fieldlets_field_filter)
						end						
						
						fieldlets = {}
						
						# Load all the fieldlets, push them to a hash by the entity_id
						loaded_fieldlets = fieldlets_set.all
						loaded_fieldlets.each do |fieldlet|
							fieldlet.entity_load_callback.call(entities_to_load) if fieldlet.entity_load_callback
							
							fieldlets[fieldlet.entity_id] ||= []
							fieldlets[fieldlet.entity_id] << fieldlet
						end
						
						# load all the entities
						entities = Entity.filter(:id => entities_to_load.keys).all
											
						# iterate each loaded entity, run callbacks and push fieldlets
						entities.each do |entity|
							# run callbacks
							if (!entities_to_load[entity.id].empty?)
								entities_to_load[entity.id].each{|callback| callback.call(entity)}
							end
							
							# init the fieldlets for the loaded entity, if there are fieldlets
							entity.init_fieldlets(fieldlets[entity.id] || []) if fieldlets[entity.id] 
						end
						
						
						
						
						# prepare result 
						
						# return only requested entities
						result = entities.find_all{|x| ids.include? x.id}
						
						# return nil if there are no results
						return result = nil if result.empty?
						
						# return only the entity if the result array size is 1
						result = result.first if result.size == 1
						
						return result
				end
				
		 #end ClassMethods
			
	end
end