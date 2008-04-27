# 
# = EntityDataManipulation
# A module which correspond to loading the entities with the fieldlets,
# match them to the fields and etc.
#
# = Updating or creating entity: (post parameters)
# 	* entity[<fieldlet_id>] = <value> => will set the value of the proper
# 																			 fieldlet (instance_id => 0)
#   * entity[<fieldlet_id>][<instance_id>] = <value> will set the value of the
# 																								  proper fieldlet, with the 
# 																									given instance id




module App
	module EntityDataManipulation
		
		# Include Hook
		def self.included(base)
			base.send(:include, InstanceMethods)
			base.extend(ClassMethods)
		end
		
		module InstanceMethods
			
			
			# simple assocs:
			def fieldlets
				Fieldlet.filter(:entity_id => self.id)
			end
			
			
			# sets the fieldlets
			def fieldlets=(value_hash)
				set_fieldlets(value_hash)
			end
			
			
			# used for a cached access to loaded fieldlets. 
			# if non loaded, load them
			def cached_fieldlets
				@fieldlets || load_fieldlets
			end
			
			# loads fieldlets into the cache
			# optional filter can be passed.
			#
			# = Example:
			# * load_fieldlets(:kind => [1,2,3,4]) # loads only fieldlet from kind (1,2,3,4)
			# * load_fieldlets(:instance_id => 1) # only fieldlets with instance_id => 1
			
			def load_fieldlets(filter = nil)
				set = fieldlets
				set = set.filter(filter) if filter
				# generate indexed fieldlets hash
				if self.new?
					return init_fieldlets([])
				else
					return init_fieldlets(set.all)
				end
			end
			
			def init_fieldlets(fieldlets)
				@fieldlets = FieldletHash.new(self,fieldlets)
			end
			
			# sets the fieldlets by the given hash
			# 
			#
			def set_fieldlets(fieldlet_hash)				
				cached_fieldlets.set(fieldlet_hash)
			end
			
			def fieldlet_loaded?
				not @fieldlets.nil? 
			end
			
			
			# = fields
			
			def fields
				@fields || init_fields
			end
			
			
			def init_fields
				@fields = self.field_kinds.collect{|f| f.new(self)}
			end
			
			
			# somthing else here
			
			def field_kinds
				self.class.field_kinds
			end
	
			def fieldset_kinds
				self.class.fieldset_kinds
			end
			
			
			def display
				@values[:display]
			end
			
			#
			# save entity with it's fieldlets
			#

			def save
				return super unless @fieldlets # if no fieldlets, save the normal way
				return false unless @fieldlets.validate
				
				self.db.transaction do
					super #call for the inherited save action - saves the entity
					@fieldlets.save!
				end
				return true
			end
		
			
		end # InstanceMethods
		
		module ClassMethods
				
				# load the entities and the fieldlets. 
				# returns a single entity or an arry of entities
				#
				# first, loads all the fieldlets, fetch it to the entities
				#
				#
				#
				
				def with_fieldlets(*ids)
						ids = ids.collect{|x| x.to_i}
					
						entities_to_load = {}
						## setup hash for entities loading and callbacks
						ids.each{|id| entities_to_load.merge!(id => [])}
						
						fieldlets_set = Fieldlet.filter(:entity_id => ids)
						
						fieldlets = {}
						
						fieldlets_set.all.each do |fieldlet|
							entities_to_load = fieldlet.setup_entities_loading_and_callbacks(entities_to_load)
							
							fieldlets[fieldlet.entity_id] ||= []
							fieldlets[fieldlet.entity_id] << fieldlet
						end
						
						entities = Entity.filter(:id => entities_to_load.keys).all
						
						entities.each do |entity|
							# run callbacks
							if (!entities_to_load[entity.id].empty?)
								entities_to_load[entity.id].each{|callback| callback.call(entity)}
							end
							
							entity.init_fieldlets(fieldlets[entity.id] || [])
						end
						
						
						
						# prepare result 
						result = entities.find_all{|x| ids.include? x.id}
						result = nil if result.empty?
						result = result.first if result.size == 1
						
						
						return result
				end
				
				# creates an entity with a specific kind
				def create_with_kind(values)
					model = self.get_subclass_by_id(values['kind'])
					model.create(values)
				end
		end # ClassMethods
			
	end
end