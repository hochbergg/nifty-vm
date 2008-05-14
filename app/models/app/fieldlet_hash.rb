#
# = FieldletHash
# this is a special hash, used for storing fieldlets and their instances
#
# = Usage:
#  
# init:
#  fieldlet_hash = FieldletHash.new(entity, fieldlets)
#
# set fieldlets values:
#  fieldlet_hash.set({1 => 'Text', 2 => {0 => 'text1', 1 => 'text2'}})
# 
# saveing the fieldlets
#  fieldlet_hash.save
#
# accessing fieldlets:
#  fieldlet_hash[<fieldlet_kind>][<instance_id>] => fieldlet object

module App
	class FieldletHash
		def initialize(entity,fieldlets = [])
			@entity = entity
			@fieldlet_hash = {}
			@pending_for_save = []
			
			# build the skeleton hash
			entity.class.fieldlet_kind_ids.each{|fid| @fieldlet_hash.update(fid => {})}
			
			# fill the hash with the given fieldlets
			fieldlets.each do |fieldlet|
				@fieldlet_hash[fieldlet.kind].update(fieldlet.instance_id => fieldlet)
			end
		end
		
		# updates the fieldlets
		def set(fieldlet_hash)
			fieldlet_hash.each do |key, value|
				if value.kind_of? Hash # gave a list with 
					value.each do |instance_id, instance_value|
						raise 'Bad Fieldlet type' unless fieldlet = @fieldlet_hash[key.to_i]
						fieldlet = fieldlet[instance_id.to_i]
						fieldlet ||= Fieldlet.get_subclass_by_id(key).new
						fieldlet.value = instance_value
						fieldlet[:instance_id] = instance_id
						fieldlet[:entity_id] = @entity_id
						@fieldlet_hash[key.to_i][instance_id] = fieldlet
						
						# add to the pending_for_save queue
						@pending_for_save << fieldlet
					end
				else 
					raise 'Bad Fieldlet type' unless fieldlet = @fieldlet_hash[key.to_i]
					fieldlet = fieldlet[0]
					fieldlet ||= Fieldlet.get_subclass_by_id(key).new
					fieldlet.value = value
					fieldlet[:instance_id] = 0
					fieldlet[:entity_id] = @entity_id
					@fieldlet_hash[key.to_i][0] = fieldlet
					
					# add to the pending_for_save queue
					@pending_for_save << fieldlet
				end
			end
		end
		
		def validate
			#TODO: implement
			return true
		end
		
		# saves all the pending fieldlets without validation
		def save!
			@pending_for_save.each do |fieldlet|
				fieldlet[:entity_id] =  @entity.id
#				fieldlet.entity_save_callback.call(@entity, @pending_for_save) if fieldlet.entity_save_callback
				fieldlet.save
			end
		end
		
		def save
			save! if validate
			return true
		end

		def fieldlets
			@fieldlet_hash
		end
		
		# get all the fieldlet objects
		def all
			@fieldlet_hash.values.collect{|x| x.values}.flatten
		end
	end # class
end