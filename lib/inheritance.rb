#
# = Inheritance module. 
# Enable STI-like abilities 

module Inheritance
	# Include Hook
	def self.included(base)
		base.send(:include, InstanceMethods)
		base.extend ClassMethods
	end
	
	module InstanceMethods
			
	end # InstanceMethods
	
	module ClassMethods

		# = Inherited
		# 
		
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
			klass.set_dataset(klass.dataset.dup.filter(:kind => id))
		end

		# return the model
		def get_subclass_by_id(id)
			self.dataset.opts[:models][id.to_i]
		end

	end # ClassMethods
	
	
end