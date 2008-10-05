module App
	class Field
		##
		# Renders to field in JSON
		#
		# @param [*] *args, args to pass to the to_json method
		#
		# @return [String] json encoded field instance
		#
		def to_json(*args)
			return @fieldlets.merge({:instance => self.instance_id().to_s}).to_json(*args)
		end
	end
end