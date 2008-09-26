module App
	class Field
		def to_json(*args)
			return @fieldlets.merge({:instance => self.instance_id().to_s}).to_json(*args)
		end
	end
end