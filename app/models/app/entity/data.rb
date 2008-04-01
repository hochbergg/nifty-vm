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
		
				# load multi entities with their fieldlets
				# 
				# TODO: move to dataset
				def all_with_fieldlets(fieldlet_filter = nil)
					entities = self.all
					fieldlets_set = Fieldlet.filter(:entity_id => entities.collect{|e| e.id})
					fieldlets_set = fieldlets_set.filter(fieldlet_filter) if fieldlet_filter
					
					fieldlets = {}
					
					# index fieldlets per entity_id
					fieldlets_set.all.each do |fieldlet|
						fieldlets[fieldlet.entity_id] ||= []
						fieldlets[fieldlet.entity_id] << fieldlet
					end
					
					# fill entities with fieldlets
					entities.each do |entity|
						entity.init_fieldlets(fieldlets[entity.id] || [])
					end
					
					# return the entities
					return entities
				end
				
				
				# will load a specific entity with its fieldlets
				def one_with_fieldlets(condition)
					entity = Entity[condition]
					raise App::EntityNotFoundException unless entity
					
					entity.load_fieldlets
					return entity
				end
				
				# creates an entity with a specific kind
				def create_with_kind(values)
					model = self.get_subclass_by_id(values['kind'])
					model.create(values)
				end
		end # ClassMethods
			
	end
end