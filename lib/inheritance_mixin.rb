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

		# == Inherited callback
		# 
		# Called when a class inherit from the mixed-in class
		#
		# Sets the subclass' dataset, maps the superclass model for STI-ing to the 
		# subclass model if the type matches
		
		def inherited(klass)
			
			# extract the inheritance id from the given klass
			# Entity3 => 3
			# TODO: can we make it prettier?
			id = klass.to_s.scan(/\d+$/).first.to_i
						
			# add to our dataset models hash
			models = self.dataset.opts[:models].update(id => klass)
			
			# update the model dataset to be polymorphic
			self.dataset.set_model(:kind, models)
			
			# set the inheriting model to filter by the id
			klass.set_dataset(self.dataset.clone.filter(:kind => id))
			klass.set_primary_key :id # set the default primary key
		end

		# gets a subclass model by an id
		def get_subclass_by_id(id)
			self.dataset.opts[:models][id.to_i]
		end

	end # ClassMethods
	
	
end