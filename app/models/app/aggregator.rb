# Aggregtors holds set of rules on fieldlets, 
# can be cached, and can be fetched
# returns the fieldlets that matched / entity ids that matched

module App
	class Aggregator
		
		# options_hash options: 
		# * filters -> list of filters
		# * cached -> boolean
		
		def initalize(options_hash = {})
			@filters = options_hash[:filters] || []
		end
		
		
	end
end