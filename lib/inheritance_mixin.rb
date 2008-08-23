# = InheritanceMixin
#
# Allows for a model to have automatic integer based STI
#

module InheritanceMixin
	# Include Hook
	def self.included(base)
		base.extend ClassMethods
	end
		
	module ClassMethods
		
		def set_inheritance!
			id = self::IDENTIFIER
			superclass_dataset = self.superclass.dataset
			
			# add to our dataset models hash
			models = superclass_dataset.opts[:models].update(id => self)
			
			# update the model dataset to be polymorphic
			superclass_dataset.set_model(:kind, models)
			
			# set the inheriting model to filter by the id
			self.set_dataset(superclass_dataset.clone.filter!(:kind => id))
			self.set_primary_key self.superclass.primary_key # set the default primary key
		end

		# gets a subclass model by an id
		def get_subclass_by_id(id)
			model = self.dataset.opts[:models][id]
			raise "Subclass mismatch (#{id})" if !model
			return model
		end

	end # ClassMethods
	
	
end