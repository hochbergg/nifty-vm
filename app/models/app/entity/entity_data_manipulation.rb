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
	module EntityDataManipulation
		
		# Include Hook
		def self.included(base)
			base.send(:include, InstanceMethods)
			base.extend(ClassMethods)
		end
		
		module InstanceMethods			

			# Datasets
			def fieldlets_dataset
				Fieldlet.filter(:entity_id => self.id)
			end
			
			# sets the fieldlets
			def fieldlets=(value_hash)
				set_fieldlets(value_hash)
			end
			
			
			# used for a cached access to loaded fieldlets. 
			# if non loaded, load them
			def fieldlets
				@fieldlets || load_fieldlets
			end
			
			# load the fieldlets for this instance
			#
      # ==== Parameters
			# filter<Hash>:: a hash filter, to filter on the loaded feildlets. defaults to nil
			#
			
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
			
			# Sets the entity's fieldlet hash
			#
			# ==== Parameters
      # fieldlets<Array>:: array of fieldlets to fill the fieldlethash
			#
			def init_fieldlets(fieldlets)
				@fieldlets = FieldletHash.new(self,fieldlets)
			end
			
			# Updates the fieldlets in the fieldlets hash with a new hash
			# 
			# ==== Parameters
      # fieldlet_hash<Hash>:: a hash which will used to update the fieldlet hash
			#
			# ==== Example
			#
			# set_fieldlets({1 => 'Text', 2 => {0 => 'text1', 1 => 'text2'}})
			#
			# More information can be obtained at FieldletHash#set

			def set_fieldlets(fieldlet_hash)				
				self.fieldlets.set(fieldlet_hash)
			end


			# Checks if the fieldlet hash has been initialized
			#
			# ==== Returns
			# <Boolean>:: true if initialized, false if not
			def fieldlet_loaded?
				not @fieldlets.nil? 
			end
			
			
			# Accessor for the fields
			# if no fieldls were initialized, initalize the fields
			def fields
				@fields || init_fields
			end
			
			
			# Initialize the fields
			def init_fields
				@fields = self.field_kinds.collect{|f| f.new(self)}
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
				
				def find_with_fieldlets(*args)
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
						
						fieldlets_set = Fieldlet.filter(:entity_id => ids)
						
						# Apply a fieldlets filter if given
						fieldlets_set.filter(options_hash[:fieldlets_set]) if options_hash[:fieldlets_set]
						
						
						fieldlets = {}
						
						# Load all the fieldlets, push them to a hash by the entity_id
						fieldlets_set.all.each do |fieldlet|
							entities_to_load = fieldlet.setup_entities_loading_and_callbacks(entities_to_load)
							
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
						result = nil if result.empty?
						
						# return only the entity if the result array size is 1
						result = result.first if result.size == 1
						
						return result
				end
				
		end # ClassMethods
			
	end
end